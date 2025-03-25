%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Running this MATLAB script will generate the figure 2 in the project
% report. The plot of ReLu is generated using the files located in tha
% folder 'CNN Estimators' as mentioned in the report.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clearvars
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add necessary folders to path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('MMSE estimators\CNN Estimator',...
        'MMSE estimators\Other Estimators',...
        'Error functions',...
        'Helpers');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
antennas    = [8, 16, 32, 64, 96, 128];     % Number of antennas at base station
nCoherence  = 1;                            % Number of coherence times the observations are collected
snr         = 0;                            % Signal to noise ratio in dB

AS          = 2.0;                          % Angular spread of each path
nPaths      = 3;                            % Number of paths

nBatches    = 20;                           % Number of batches of channel realization
trials      = 1000;                         % Number of trials over which the errors are averaged


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initializations and error calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Structure with function handles that will calculate the mean square error
% for different types of estimators
cal_err     = @(estimator, nAntennas, snr, nBatches, trials, nCoherence, AS, nPaths)...
                estimator(nAntennas, snr, nBatches, trials, nCoherence, AS, nPaths);

% Types of estimators
types       = { @e_GenieOMP,...
                @e_ML,...
                @e_FastMMSE,...
                @e_ToepMMSE,...
                @e_GenieMMSE};

n_antennas  = length(antennas);
n_types     = length(types);
err         = zeros(n_antennas, n_types);

fprintf('--------------------------------------\n')
fprintf(' Simulating with antennas: ')

for iAntennas = 1:n_antennas
    
    nAntennas = antennas(iAntennas);
    fprintf('\n %d  ', nAntennas)
    
    for itype = 1:n_types
        
        fprintf('.')
        err(iAntennas, itype) = cal_err(types{itype}, nAntennas, snr,...
                                        nBatches, trials, nCoherence,...
                                        AS, nPaths);

    end
end
        
fprintf('\n--------------------------------------\n')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cla

plot(antennas, err(:, 1), 'p-.')
hold on
plot(antennas, err(:, 2), 'k--o')
plot(antennas, err(:, 3), 'b--x')
plot(antennas, err(:, 4), 'r--s')
plot(antennas, err(:, 5), '--')
hold off

xlabel('Number of antennas at the base station')
ylabel('Normalized MSE')
legend('Genie OMP O(M log M)',...
        'ML O(M logM)',...
        'FE O(M log M)',...
        'Toeplitz SE O(M^2)',...
        'Genie Aided')
axis tight
grid on
ax = gca;
ax.GridLineStyle = '-';
ax.GridColor = 'k';
ax.GridAlpha = .3;

