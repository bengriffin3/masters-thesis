     
# -*- coding: utf-8 -*-
 
from itertools import product

import numpy as np
import pandas as pd

import os, glob
import os.path as op
import json, pprint



data_dyn_graph = json.load(open(os.path.join("params_dyn_graph.json")))

pprint.pprint({'graph parameters': data_dyn_graph})

data_path = data_dyn_graph["data_path"]
subject_ids = data_dyn_graph["subject_ids"]
freq_bands = data_dyn_graph["freq_bands"]
conf_interval_prob = data_dyn_graph["conf_interval_prob"]

con_den = data_dyn_graph["con_den"]
str_con_den = str(con_den).replace(".","_")


def gather_rada_values():

    import numpy as np
    import pandas as pd

    import os,glob

    from graphpype.gather.gather_permuts import (compute_signif_permuts,
                                                 compute_rada_df)

    all_global_info_values = []

    for subj in subject_ids:

        for freq in freq_bands:

            local_dir=os.path.join(
                data_path, "mat_to_dyn_graph",
                "graph_den_pipe_den_" + str(con_den).replace('.','_'),
                "_freq_band_" + freq + "_subject_id_" + subj)

            print(local_dir)
            print(os.path.exists(local_dir))

            nb_splits = len(glob.glob(os.path.join(local_dir,
                                               'compute_net_List',
                                               'mapflow',
                                               '_compute_net_List*')))

            print(nb_splits)

            dict_global_info_values = {'Freq':[freq]*nb_splits, 'Subject':[subj]*nb_splits}

            compute_rada_df(iter_path=local_dir, df=dict_global_info_values,
                            radatools_version = "5.0",
                            mapflow = range(nb_splits), mapflow_name = "Split")

            print(dict_global_info_values)

            df_sess = pd.DataFrame(dict_global_info_values)

            print(df_sess)

            all_global_info_values.append(df_sess)

    df = pd.concat(all_global_info_values)

    print(df)

    csv_filename=os.path.join(
        data_path,
        "Results_rada_den_"+str_con_den+'_all_infos.csv')

    df.to_csv(csv_filename)

#def gather_node_results():

    #from graphpype.gather.gather_permuts import compute_nodes_rada_df
    
    #gm_coords = np.array(np.loadtxt(ROI_MNI_coords_file),dtype = int) ### attention, dtype forc� a int pour compatibilit� avec les coords de sep_coords, mais pas n�cessaire dans l'absolu....
    
    #print (gm_coords)
    
    #writer =pd.ExcelWriter(os.path.join(
        #data_path,
        #"Results_rada_den_"+str_con_den+"_all_node_properties.xls"))

    #for sess in func_sessions:
        
        #print (sess)
        
        ##### network definition
        #coords_file = ROI_MNI_coords_file
        
        #labels_file = ROI_labels_file
        
        #for subj in subject_ids:
        
            #local_dir = os.path.join(
                #data_path, "nii_to_dyn_graph",
                #"graph_den_pipe_den_"+str_con_den,
                #"_session_"+sess+"_subject_id_"+subj)
            
            #list_df = compute_nodes_rada_df(local_dir, gm_coords, coords_file,
                #labels_file, mapflow = range(19), mapflow_name = "Split")

            #if len(list_df) != 0:

                #all_node_results = pd.concat(list_df,axis = 0)

                #print (all_node_results)

                #all_node_results.to_excel(writer,
                                          #"sess_"+sess+"_subject_num_"+subj)

            #else:
                #print ("Warning, empty df for subj {} sess \
                    #{}".format(subj, sess))

    #writer.save()

if __name__ =='__main__':
    
    ### gathering results by nodes 
    #gather_node_results()
    
    #### gathering global results
    gather_rada_values()
