import numpy as np
import tensorflow as tf
import pandas as pd
import xlsxwriter

# Input and output of the NN are complex-valued vectors of dimension `nCoherence, nFilterLength`
# where `nFilterLength` is calculated from `nAntennas` and `transform`.
# For mini-batch training, these are stacked into three dimensional arrays of dimension
# `nBatches, nCoherence, nFilterLength`.
# This method performs a random initialization of all kernels and biases.

#System model parameters

#Specify the number of antennas the CNN needs to be trained and tested
antennas = np.array([8])

#Specify the number of batches each time channel realizations are generated
nBatches = 20

#Neural Network parameters
nLayers = 2
reg_coeff = 1e-6

#Specify number of training batches, testing batches and number of epochs the neural net is going to be trained for each training batch
nLearningBatches = 500
nTestBatches = 100
epochs = 20

nantenna = len(antennas)
errs = np.zeros(nantenna)

for iAntenna in range(nantenna):

    tf.reset_default_graph()
    
    nAntennas = antennas[iAntenna]
    
    #The learning rate is made dependent on number of antennas
    learning_rate = (64/nAntennas)*1e-4
    
    ##############################################################################
    ############################ LOAD SAVED XLS FILES ############################
    ##############################################################################
    
    #Import MATLAB generated channels
    train_folder = "Train data\\"
    test_folder = "Test data\\"
    
    # Load train variables
    x0_toep1_real_file = train_folder + "x0_toep1_real_" + str(nAntennas) + ".xls"
    x0_toep1_imag_file = train_folder + "x0_toep1_imag_" + str(nAntennas) + ".xls"
    x0_toep2_real_file = train_folder + "x0_toep2_real_" + str(nAntennas) + ".xls"
    x0_toep2_imag_file = train_folder + "x0_toep2_imag_" + str(nAntennas) + ".xls"
    
    y_toep1_real_file = train_folder + "y_toep1_real_" + str(nAntennas) + ".xls"
    y_toep1_imag_file = train_folder + "y_toep1_imag_" + str(nAntennas) + ".xls"
    y_toep2_real_file = train_folder + "y_toep2_real_" + str(nAntennas) + ".xls"
    y_toep2_imag_file = train_folder + "y_toep2_imag_" + str(nAntennas) + ".xls"
    
    y_mean1_file = train_folder + "y_mean1_" + str(nAntennas) + ".xls"
    y_mean2_file = train_folder + "y_mean2_" + str(nAntennas) + ".xls"
    
    x0_toep1_real = pd.read_excel(x0_toep1_real_file, sheet_name = "Sheet1").values
    x0_toep1_imag = pd.read_excel(x0_toep1_imag_file, sheet_name = "Sheet1").values
    x0_toep2_real = pd.read_excel(x0_toep2_real_file, sheet_name = "Sheet1").values
    x0_toep2_imag = pd.read_excel(x0_toep2_imag_file, sheet_name = "Sheet1").values
    
    x0_toep1 = x0_toep1_real + 1j*x0_toep1_imag
    x0_toep2 = x0_toep2_real + 1j*x0_toep2_imag
    
    x0_toep_re = np.expand_dims(np.transpose(np.concatenate((x0_toep1, x0_toep2), axis = 0)), axis = 2)
    
    y_toep1_real = pd.read_excel(y_toep1_real_file, sheet_name = "Sheet1").values
    y_toep1_imag = pd.read_excel(y_toep1_imag_file, sheet_name = "Sheet1").values
    y_toep2_real = pd.read_excel(y_toep2_real_file, sheet_name = "Sheet1").values
    y_toep2_imag = pd.read_excel(y_toep2_imag_file, sheet_name = "Sheet1").values
    
    y_toep1 = y_toep1_real + 1j*y_toep1_imag
    y_toep2 = y_toep2_real + 1j*y_toep2_imag
    
    y_toep_re = np.expand_dims(np.transpose(np.concatenate((y_toep1, y_toep2), axis = 0)), axis = 2)
    
    y_mean1 = pd.read_excel(y_mean1_file, sheet_name = "Sheet1").values
    y_mean2 = pd.read_excel(y_mean2_file, sheet_name = "Sheet1").values
    
    y_mean_re = np.transpose(np.concatenate((y_mean1, y_mean2), axis = 0))
    
    # Load test variables    
    x0_org_real_file = test_folder + "x0_org_real_" + str(nAntennas) + ".xls"
    x0_org_imag_file = test_folder + "x0_org_imag_" + str(nAntennas) + ".xls"
    
    y_toep1_real_test_file = test_folder + "y_toep1_real_" + str(nAntennas) + ".xls"
    y_toep1_imag_test_file = test_folder + "y_toep1_imag_" + str(nAntennas) + ".xls"
    y_toep2_real_test_file = test_folder + "y_toep2_real_" + str(nAntennas) + ".xls"
    y_toep2_imag_test_file = test_folder + "y_toep2_imag_" + str(nAntennas) + ".xls"
    
    y_mean1_test_file = test_folder + "y_mean1_" + str(nAntennas) + ".xls"
    y_mean2_test_file = test_folder + "y_mean2_" + str(nAntennas) + ".xls"
    
    x0_org_real = pd.read_excel(x0_org_real_file, sheet_name = "Sheet1").values
    x0_org_imag = pd.read_excel(x0_org_imag_file, sheet_name = "Sheet1").values
    
    x0_org = x0_org_real + 1j*x0_org_imag
    x0_org_re = np.expand_dims(np.transpose(x0_org), axis = 2)
    
    y_toep1_real_test = pd.read_excel(y_toep1_real_test_file, sheet_name = "Sheet1").values
    y_toep1_imag_test = pd.read_excel(y_toep1_imag_test_file, sheet_name = "Sheet1").values
    y_toep2_real_test = pd.read_excel(y_toep2_real_test_file, sheet_name = "Sheet1").values
    y_toep2_imag_test = pd.read_excel(y_toep2_imag_test_file, sheet_name = "Sheet1").values
    
    y_toep1_test = y_toep1_real_test + 1j*y_toep1_imag_test
    y_toep2_test = y_toep2_real_test + 1j*y_toep2_imag_test
    
    y_toep_re_test = np.expand_dims(np.transpose(np.concatenate((y_toep1_test, y_toep2_test), axis = 0)), axis = 2)
    
    y_mean1_test = pd.read_excel(y_mean1_test_file, sheet_name = "Sheet1").values
    y_mean2_test = pd.read_excel(y_mean2_test_file, sheet_name = "Sheet1").values
    
    y_mean_re_test = np.transpose(np.concatenate((y_mean1_test, y_mean2_test), axis = 0))
    
    ########################################
    ### Load interpolated kernels and biases
    ########################################
    
    if nAntennas != 8:
        
        hier_folder = 'Hier Training/'
        
        kernel_inter_file = hier_folder + "kernel_interp_" + str(nAntennas) + ".xls"
        biases_inter_file = hier_folder + "biases_interp_" + str(nAntennas) + ".xls"
        
        kernel_interp = pd.read_excel(kernel_inter_file, sheet_name = "Sheet1").values
        biases_interp = pd.read_excel(biases_inter_file, sheet_name = "Sheet1").values
    
    #######################################################################################
    ###################################### BUILD CNN ######################################
    #######################################################################################
    
    #Inputs to the CNN
    y_actual = tf.placeholder(tf.complex64, name = "y_actual")
    x0 = tf.placeholder(tf.complex64, name = "x0")
    y = tf.placeholder(tf.float32, name = "y_tf")
    
    nFilterlength = 2*nAntennas #For toeplitz transformation, 2 is multiplied because the DFT matrix has twice as number of rows as the circulant matrix
    
    if nAntennas != 8:
        kernel = tf.cast(tf.get_variable("kernel", initializer = kernel_interp), dtype = 'float32')
        biases = tf.cast(tf.get_variable("biases", initializer = biases_interp), dtype = 'float32')
    else:
        kernel = tf.get_variable("kernel", [nLayers, nFilterlength], initializer = tf.truncated_normal_initializer(mean = 0.0, stddev = 0.1))
        biases = tf.get_variable("biases", initializer = tf.fill([nLayers, nFilterlength], 0.1))
    
    #Processing the kernel
    kernel_rev = tf.reverse([kernel[0][:]], [1])
    kernel_tile = tf.transpose(tf.tile(kernel_rev, [1, 2]))
    kernel_feed = tf.expand_dims(tf.expand_dims(kernel_tile, axis = 2), axis = 3)
    
    #2D convolution
    conv_2d = tf.squeeze(tf.nn.conv2d(y, kernel_feed, strides = [1, 1, 1, 1], padding = 'SAME'))
    
    #Add bias
    add_bias = conv_2d + biases[0][:]
    
    #Activation function
    inter1 = tf.nn.relu(add_bias)
    
    inter1_conv = tf.expand_dims(tf.expand_dims(inter1, axis = 0), axis = 3)
    
    #Processing the second kernel
    kernel_rev2 = tf.reverse([kernel[1][:]], [1])
    kernel_tile2 = tf.tile(kernel_rev2, [1, 2])
    kernel_feed2 = tf.expand_dims(tf.expand_dims(kernel_tile2, axis = 2), axis = 3)
    
    #2D convolution
    conv_2d2 = tf.squeeze(tf.nn.conv2d(inter1_conv, kernel_feed2, strides = [1, 1, 1, 1], padding = 'SAME'))
    
    #Add bias to last layer
    filt = conv_2d2 + biases[1][:]
    
    #Reshape filt for multiplication
    filt_re = tf.reshape(tf.transpose(filt), [nFilterlength, nBatches, 1])
    
    #Multiply filter with y
    est_x = tf.multiply(tf.cast(filt_re, dtype='complex64'), y_actual)
    
    # Set learning parameters
    # regularization term
    regu = tf.reduce_mean(tf.square(kernel[0][:]) + tf.square(kernel[1][:])) 
    
    # loss calculation
    loss = tf.reduce_mean(tf.real(est_x - x0)**2 + tf.imag(est_x - x0)**2) + regu*reg_coeff
    
    #Optimize loss
    optimizer = tf.train.AdamOptimizer(learning_rate).minimize(loss)
    
    #######################################################################################
    ###################################### TRAIN CNN ######################################
    #######################################################################################
    
    with tf.Session() as sess:
            
        sess.run(tf.global_variables_initializer())
            
        remaining = epochs*nLearningBatches  
        
        for n_train in range(nLearningBatches):
                        
            offset = 2*nAntennas*n_train
            ind = offset + np.array(range(2*nAntennas))
            
            y_mean = y_mean_re[:, ind]
            y_trans = y_toep_re[:, ind, :]
            x0_trans = x0_toep_re[:, ind, :]
            
            y_perm = np.transpose(y_trans, (1, 0, 2))
            y_feed = np.expand_dims(np.expand_dims(y_mean, axis = 0), axis = 3)
            
            x0_perm = np.transpose(x0_trans, (1, 0, 2))
            
            print('Loss before optimization:')
            print(sess.run(loss, feed_dict = {y: y_feed, y_actual: y_perm, x0: x0_perm}))
            
            for _ in range(epochs):
                
                remaining += -1
                print(remaining)
                sess.run(optimizer, feed_dict = {y: y_feed, y_actual: y_perm, x0: x0_perm})
            
            print('Loss after optimization:')
            print(sess.run(loss, feed_dict = {y: y_feed, y_actual: y_perm, x0: x0_perm}))
    
    ######################################################################################
    ###################################### TEST CNN ######################################
    ######################################################################################
    
        for n_test in range(nTestBatches):
                        
            offset = 2*nAntennas*n_test
            ind = offset + np.array(range(2*nAntennas))
            ind8 = offset - nAntennas*n_test + np.array(range(nAntennas))
            
            y_mean = y_mean_re_test[:, ind]
            y_trans = y_toep_re_test[:, ind, :]
            x0_test = x0_org_re[:, ind8, :]
                
            #Permutation       
            y_perm = np.transpose(y_trans, (1, 0, 2))                    
            y_feed = np.expand_dims(np.expand_dims(y_mean, axis = 0), axis = 3)
            
            #Estimated sequence 
            x = sess.run(est_x, feed_dict = {y: y_feed, y_actual: y_perm})
            
            #Permutation
            x_perm = np.transpose(x, (1, 0, 2))
            
            #Toeplitz_Trans with transpose    
            temp = np.fft.ifft(x_perm, axis = 1)
            trunc = np.int(temp.shape[1]/2)
            x_trans = temp[:, range(trunc), :]*np.sqrt(x_perm.shape[1])
            
            if len(x_perm.shape) == 2:
                x_trans = x_trans[1, :, :]
    
            errs[iAntenna] += np.sum(np.abs(x0_test - x_trans)**2)/nBatches/nTestBatches/nAntennas
                
        ##############################
        ### Save the kernel and biases
        ##############################
        
        kernel_out, biases_out = sess.run((kernel, biases))
        
        hier_folder = 'Hier Training/'
        
        workbook1 = xlsxwriter.Workbook(hier_folder + 'kernel_old_' + str(nAntennas) + '.xls') 
        workbook2 = xlsxwriter.Workbook(hier_folder + 'biases_old_' + str(nAntennas) + '.xls')
        
        worksheet1 = workbook1.add_worksheet()
        worksheet2 = workbook2.add_worksheet()
        
        for i in range(kernel_out.shape[0]):
            for j in range(biases_out.shape[1]):
                
                worksheet1.write(i, j, kernel_out[i, j])
                worksheet2.write(i, j, biases_out[i, j])
                
        workbook1.close()
        workbook2.close()

print(errs)
