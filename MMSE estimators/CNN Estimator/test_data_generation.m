function test_data_generation(nAntennas, snr, nBatches, nTestingBatches, nCoherence, AS, nPaths)

test_folder = 'MMSE estimators/CNN Estimator/Test data/';

n_row = nAntennas*nTestingBatches;

x0_org = zeros(n_row, nBatches);
y_toep_t = zeros(n_row, nBatches);
y_mean_t = zeros(n_row, nBatches);

j = 1;

fprintf(' Generating test data for antennas: %d\n', nAntennas)

for i = 1:nAntennas:n_row

    [x0, ~] = generate_channel(nAntennas, nPaths, AS, nCoherence, nBatches);
    y = x0 + 10^(-snr/20)*crandn2(size(x0));
    
    x0_org(i:i + nAntennas - 1, :) = x0(:, 1, :);
    
    y_toep = toep_trans(y, 'notransp');
    y_mean = abs(y_toep).^2;
    
    y_toep_t(j:j + 2*nAntennas - 1, :) = y_toep(:, 1, :);
    y_mean_t(j:j + 2*nAntennas - 1, :) = y_mean(:, 1, :);
    
    j = j + 2*nAntennas;
    
end

%Modify data for python format
x0_org = [zeros(1, nBatches); x0_org];

y_toep_1 = [zeros(1, nBatches); y_toep_t(1:end/2, :)];
y_toep_2 = [zeros(1, nBatches); y_toep_t(end/2+1:end, :)];

y_mean_1 = [zeros(1, nBatches); y_mean_t(1:end/2, :)];
y_mean_2 = [zeros(1, nBatches); y_mean_t(end/2+1:end, :)];

%Create filenames
x0_org_real_file = strcat(test_folder, 'x0_org_real_', num2str(nAntennas), '.xls');
x0_org_imag_file = strcat(test_folder, 'x0_org_imag_', num2str(nAntennas), '.xls');

y_toep_file_1_real = strcat(test_folder, 'y_toep1_real_', num2str(nAntennas), '.xls');
y_toep_file_1_imag = strcat(test_folder, 'y_toep1_imag_', num2str(nAntennas), '.xls');

y_toep_file_2_real = strcat(test_folder, 'y_toep2_real_', num2str(nAntennas), '.xls');
y_toep_file_2_imag = strcat(test_folder, 'y_toep2_imag_', num2str(nAntennas), '.xls');

y_mean_file1 = strcat(test_folder, 'y_mean1_', num2str(nAntennas), '.xls');
y_mean_file2 = strcat(test_folder, 'y_mean2_', num2str(nAntennas), '.xls');

%Delete existing files if exists
if exist(x0_org_real_file, 'file') == 2
    delete(x0_org_real_file);
end 
if exist(x0_org_imag_file, 'file') == 2
    delete(x0_org_imag_file);
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
if exist(y_mean_file1, 'file') == 2
    delete(y_mean_file1);
end 
if exist(y_mean_file2, 'file') == 2
    delete(y_mean_file2);
end 

%Write data to excel files
xlswrite(x0_org_real_file, real(x0_org))
xlswrite(x0_org_imag_file, imag(x0_org))

xlswrite(y_toep_file_1_real, real(y_toep_1))
xlswrite(y_toep_file_1_imag, imag(y_toep_1))

xlswrite(y_toep_file_2_real, real(y_toep_2))
xlswrite(y_toep_file_2_imag, imag(y_toep_2))

xlswrite(y_mean_file1, y_mean_1)
xlswrite(y_mean_file2, y_mean_2)

