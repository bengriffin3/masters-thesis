import numpy as np

import matplotlib.pyplot as plt


labels_file = "modules98.txt"
data_file = "Output_allegiance_matrix_power_opt_mean.npy"
# loading data
data = np.load(data_file)

print (data.shape)

# loading labels
list_labels = [line.strip()
                           for line in open(labels_file)]

# plotting data
cmap='rainbow'
label_size = 2

for i in range(data.shape[0]):

    plot_file = "alleg_mat_{}.eps".format(i)
    txt_file = "alleg_mat_{}.txt".format(i)

    cor_mat = data[i,:,:]

    print(cor_mat.shape)
    np.savetxt(txt_file, cor_mat)

    fig1 = plt.figure(frameon=False)
    ax = fig1.add_subplot(1, 1, 1)

    im = ax.matshow(cor_mat, vmin=-1,
                        vmax=1, interpolation="none")

    [i.set_visible(False) for i in ax.spines.values()]
    im.set_cmap(cmap)

    # add labels
    if len(list_labels):
        assert len(list_labels) == cor_mat.shape[0], "Error number of labels \
            {} and matrix shape {}".format(len(list_labels), cor_mat.shape[0])

        plt.xticks(list(range(len(list_labels))), list_labels,
                   rotation='vertical', fontsize=label_size)
        plt.yticks(list(range(len(list_labels))), list_labels,
                   fontsize=label_size)
        plt.subplots_adjust(top=0.8)

    # ticks
    plt.tick_params(axis='both', which='both', bottom=False, top=False,
                    left=False, right=False)
    # colorbar
    fig1.colorbar(im)
    fig1.savefig(plot_file)
    plt.close(fig1)

