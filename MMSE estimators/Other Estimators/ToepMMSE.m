function est = ToepMMSE(snr, nAntennas, nPaths, AS, nCoherence, nBatches, nSamples)

est = struct();
est.rho = 10^(snr/10);

Q = toep_trans(eye(nAntennas), 'notransp');
A = pinv(abs(Q*Q').^2);

est.W = zeros(size(Q,1), nSamples);
est.bias = zeros(nSamples, 1);
for i = 1:nSamples
    
    [~, t] = generate_channel(nAntennas, nPaths, AS, nCoherence, nBatches); % get random sample from cov. prior
    C = toeplitzHe(t);
    
    W = C/(C + 1/est.rho * eye(nAntennas));
    est.W(:, i) = A*(real(sum(Q*W .* conj(Q), 2)));
    est.bias(i) = real(log(det(eye(nAntennas) - Q'*diag(est.W(:, i))*Q)));
    
end
