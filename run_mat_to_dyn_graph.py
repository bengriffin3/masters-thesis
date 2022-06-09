"""
.. _dyn_graph_to_graph:

=========================================================
Compute connecivity matrices and graph properties from nii files
=========================================================
The nii_to_graph pipeline performs graph analysis from functional MRI file
in NIFTI format.

The **input** data should be preprocessed (i.e. realigned, coregistered, and segmented), and normalized in the same space (e.g. MNI
space) as the template used to define the nodes in the graph.

The data used in this example are the anat and func from the sub-01 in the  `OpenNeuro database ds000208_R1.0.0 <https://openneuro.org/datasets/ds000208/versions/00001>`_, after preprocessing realized with Nipype pipeline `create_preprocess_struct_to_mean_funct_4D_spm12 <https://github.com/davidmeunier79/nipype/blob/master/nipype/workflows/fmri/spm/preprocess.py>`_, with parameters:

* TR = 2.5,

* slice_timing = False

* fast_segmenting = True

* fwhm = [7.5,7.5,8]

* nb_scans_to_remove = 0

The template was generated from the HCP template called HCPMMP1_on_MNI152_ICBM2009a_nlin, by taking a mirror for the right hemisphere and compute a template with 360 ROIS - here 332 regions are kept, and time series length = 300

The **input** data should be a preprocessed, and in the same space (e.g. MNI
space) as the template used to define the nodes in the graph.
"""

# Authors: David Meunier <david_meunier_79@hotmail.fr>

# License: BSD (3-clause)
# sphinx_gallery_thumbnail_number = 2

import os
import os.path as op

import nipype.pipeline.engine as pe
import nipype.interfaces.utility as niu
import nipype.interfaces.io as nio

import json, pprint  # noqa

###############################################################################
# Then we create a node to pass input filenames to DataGrabber from nipype

data_dyn_graph = json.load(open("params_dyn_graph.json"))

pprint.pprint({'graph parameters': data_dyn_graph})

data_path = data_dyn_graph["data_path"]
subject_ids = data_dyn_graph["subject_ids"]
freq_bands = data_dyn_graph["freq_bands"]
conf_interval_prob = data_dyn_graph["conf_interval_prob"]

infosource = pe.Node(interface=niu.IdentityInterface(
    fields=['subject_id', 'freq_band']),
    name="infosource")

infosource.iterables = [('subject_id', subject_ids),
    ('freq_band', freq_bands)]

###############################################################################
# and a node to grab data. The template_args in this node iterate upon
# the values in the infosource node

datasource = pe.Node(interface=nio.DataGrabber(
    infields=['subject_id'],
    outfields= ['mat_file']),
    name = 'datasource')

datasource.inputs.base_directory = data_path
datasource.inputs.template = '%s.mat'
datasource.inputs.template_args = dict(
mat_file=[['subject_id']],
       )

datasource.inputs.sort_filelist = True

###############################################################################
# We then connect the nodes two at a time. We connect the output
# of the infosource node to the datasource node.
# So, these two nodes taken together can grab data.

def get_freq_index(freq_band, freq_bands):

    assert freq_band in freq_bands, \
        "Error, {} not in freq_bands".format(freq_band)

    return freq_bands.index(freq_band)

# workflow directory within the `base_dir`
conmat_analysis_name = 'mat_to_dyn_graph'

#from graphpype.pipelines import create_pipeline_nii_to_split_conmat # noqa
from graphpype.pipelines import create_pipeline_nii_to_conmat # noqa

main_workflow = pe.Workflow(name= conmat_analysis_name)
main_workflow.base_dir = data_path

main_workflow.connect(infosource, 'subject_id', datasource, 'subject_id')




def split_matrices (mat_file, freq_band_index):

    import os
    from scipy import io
    import numpy as np

    mat = io.loadmat(mat_file)['adjmat']

    print(mat.shape)

    assert len(mat.shape) == 5, \
        "Error, mat should have len 5 ({})".format(len(mat.shape))

    list_splitted_mat = []

    for i in range(mat.shape[2]):
        filename = os.path.abspath("chunk_{}.npy".format(i))
        np.save(filename,mat[:,:,i,0,freq_band_index])
        list_splitted_mat.append(filename)

    return list_splitted_mat

# split_mat
split_mat = pe.Node(niu.Function(
    input_names= ['mat_file', 'freq_band_index'],
    output_names = ['list_splitted_mat'],
    function = split_matrices),
    name = "split_mat")

main_workflow.connect(datasource, 'mat_file', split_mat, 'mat_file')
main_workflow.connect(infosource, ('freq_band',get_freq_index, freq_bands), split_mat, 'freq_band_index')



################################################################################
#
## This parameter corrdesponds to the percentage of highest connections retains
## for the analyses. con_den = 1.0 means a fully connected graphs (all edges
## are present)

# density of the threshold
con_den = data_dyn_graph['con_den']

# The optimisation sequence
radatools_optim = data_dyn_graph['radatools_optim']

from graphpype.pipelines import create_pipeline_conmat_to_graph_density ## noqa

graph_workflow = create_pipeline_conmat_to_graph_density(
    data_path, con_den=con_den, optim_seq=radatools_optim, multi = True)

main_workflow.connect(split_mat, 'list_splitted_mat',
                      graph_workflow, "inputnode.conmat_file")

################################################################################
## Finally, we are now ready to execute our workflow.
main_workflow.config['execution'] = {'remove_unnecessary_outputs': 'false'}

main_workflow.run()
