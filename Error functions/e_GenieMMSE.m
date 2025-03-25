function errs = e_GenieMMSE(nAntennas, snr, nBatches, trials, nCoherence, AS, nPaths)

%evaluate
errs = 0;

parfor bb = 1:trials

    [h, h_cov] = generate_channel(nAntennas, nPaths, AS, nCoherence, nBatches);
    y = h + 10^(-snr/20)*crandn2(size(h));
        
    rho = 10^(0.1*snr);
    hest = zeros(size(y));
    
    for b = 1:nBatches
        C = toeplitzHe(h_cov(:,b)); % get full cov matrix
        Cr = C + eye(nAntennas)./rho;
        hest(:, :, b) = C*(Cr\y(:, :, b));
    end
    
    errs = errs + sum(sum(abs(h - hest).^2))/trials/nBatches/nAntennas;
    
end


