function train_data_generation(nAntennas, snr, nBatches, nLearningBatches, nCoherence, AS, nPaths)

train_folder = 'MMSE estimators/CNN Estimator/Train data/';

n_row = nAntennas*nLearningBatches;

x_toep_t = zeros(n_row, nBatches);
y_toep_t = zeros(n_row, nBatches);
y_mean_t = zeros(n_row, nBatches);

j = 1;

fprintf(' Generating training data for antennas: %d\n', nAntennas)

for i = 1:nAntennas:n_row

    [x0, ~] = generate_channel(nAntennas, nPaths, AS, nCoherence, nBatches);
    y = x0 + 10^(-snr/20)*crandn2(size(x0));
    
    x_toep = toep_trans(x0, 'notransp');
    y_toep = toep_trans(y, 'notransp');
    y_mean = abs(y_toep).^2;
    
    x_toep_t(j:j + 2*nAntennas - 1, :) = x_toep(:, 1, :);
    y_toep_t(j:j + 2*nAntennas - 1, :) = y_toep(:, 1, :);
    y_mean_t(j:j + 2*nAntennas - 1, :) = y_mean(:, 1, :);
    
    j = j + 2*nAntennas;
    
end

%Modify data for python format
x_toep_1 = [zeros(1, nBatches); x_toep_t(1:end/2, :)];
x_toep_2 = [zeros(1, nBatches); x_toep_t(end/2+1:end, :)];

y_toep_1 = [zeros(1, nBatches); y_toep_t(1:end/2, :)];
y_toep_2 = [zeros(1, nBatches); y_toep_t(end/2+1:end, :)];

y_mean_1 = [zeros(1, nBatches); y_mean_t(1:end/2, :)];
y_mean_2 = [zeros(1, nBatches); y_mean_t(end/2+1:end, :)];

%Create filenames
x0_toep_file_1_real = strcat(train_folder, 'x0_toep1_real_', num2str(nAntennas), '.xls');
x0_toep_file_1_imag = strcat(train_folder, 'x0_toep1_imag_', num2str(nAntennas), '.xls');

x0_toep_file_2_real = strcat(train_folder, 'x0_toep2_real_', num2str(nAntennas), '.xls');
x0_toep_file_2_imag = strcat(train_folder, 'x0_toep2_imag_', num2str(nAntennas), '.xls');

y_toep_file_1_real = strcat(train_folder, 'y_toep1_real_', num2str(nAntennas), '.xls');
y_toep_file_1_imag = strcat(train_folder, 'y_toep1_imag_', num2str(nAntennas), '.xls');

y_toep_file_2_real = strcat(train_folder, 'y_toep2_real_', num2str(nAntennas), '.xls');
y_toep_file_2_imag = strcat(train_folder, 'y_toep2_imag_', num2str(nAntennas), '.xls');

y_mean_file_1 = strcat(train_folder, 'y_mean1_', num2str(nAntennas), '.xls');
y_mean_file_2 = strcat(train_folder, 'y_mean2_', num2str(nAntennas), '.xls');

%Delete existing files if exists
if exist(x0_toep_file_1_real, 'file') == 2
	delete(x0_toep_file_1_real);
end 
if exist(x0_toep_file_1_imag, 'file') == 2
    delete(x0_toep_file_1_imag);
end 
if exist(x0_toep_file_2_real, 'file') == 2
    delete(x0_toep_file_2_real);
end 
if exist(x0_toep_file_2_imag, 'file') == 2
    delete(x0_toep_file_2_imag);
end 
if exist(y_toep_file_1_real, 'file') == 2
    delete(y_toep_file_1_real);
end 
if exist(y_toep_file_1_imag, 'file') == 2
    delete(y_toep_file_1_imag);
end 
if exist(y_toep_file_2_real, 'file') == 2
    delete(y_toep_file_2_real);
end 
if exist(y_toep_file_2_imag, 'file') == 2
    delete(y_toep_file_2_imag);
end 
if exist(y_mean_file_1, 'file') == 2
    delete(y_mean_file_1);
end 
if exist(y_mean_file_2, 'file') == 2
    delete(y_mean_file_2);
end 

%Write data to excel files
xlswrite(x0_toep_file_1_real, real(x_toep_1))
xlswrite(x0_toep_file_1_imag, imag(x_toep_1))

xlswrite(x0_toep_file_2_real, real(x_toep_2))
xlswrite(x0_toep_file_2_imag, imag(x_toep_2))

xlswrite(y_toep_file_1_real, real(y_toep_1))
xlswrite(y_toep_file_1_imag, imag(y_toep_1))

xlswrite(y_toep_file_2_real, real(y_toep_2))
xlswrite(y_toep_file_2_imag, imag(y_toep_2))

xlswrite(y_mean_file_1, y_mean_1)
xlswrite(y_mean_file_2, y_mean_2)





