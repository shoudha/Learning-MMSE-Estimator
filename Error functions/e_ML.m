function errs = e_ML(nAntennas, snr, nBatches, trials, nCoherence, AS, nPaths)

est = CircML(snr);

%evaluate
errs = 0;

for bb = 1:trials

    [h, ~] = generate_channel(nAntennas, nPaths, AS, nCoherence, nBatches);
    y = h + 10^(-snr/20)*crandn2(size(h));

    z = circ_trans(y, 'notransp');
    
    cest = max(0, sum(abs(z).^2, 2) - nCoherence/est.rho);
    cest = reshape(cest, nAntennas, nBatches);

    W = cest./(cest + nCoherence/est.rho);
    W = reshape(W, nAntennas, 1, nBatches);

    hest = circ_trans(W.*z, 'transp');
    errs = errs + sum(sum(abs(h - hest).^2))/trials/nAntennas/nBatches;

end



