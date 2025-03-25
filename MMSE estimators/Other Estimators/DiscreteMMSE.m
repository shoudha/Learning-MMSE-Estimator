function est = DiscreteMMSE(snr, nAntennas, nPaths, AS, nCoherence, nBatches, nSamples)

est = struct();
est.rho = 10^(snr/10);

for i = 1:nSamples
    
    [~, t] = generate_channel(nAntennas, nPaths, AS, nCoherence, nBatches);
    C = toeplitzHe(t);
    nAntennas = size(C, 1);
    
    % MMSE filter at sample i
    est.W(:, :, i) = C/(C + 1/est.rho * eye(nAntennas));
    
    % bias term at sample i
    est.bias(i) = real(log(det(eye(nAntennas) - est.W(:, :, i))));
    
end
