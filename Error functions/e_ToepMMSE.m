function errs = e_ToepMMSE(nAntennas, snr, nBatches, trials, nCoherence, AS, nPaths)

nSamples = 16*nAntennas;

est = ToepMMSE(snr, nAntennas, nPaths, AS, nCoherence, 1, nSamples);

%evaluate
errs = 0;

parfor bb = 1:trials

    [h, ~] = generate_channel(nAntennas, nPaths, AS, nCoherence, nBatches);
    y = h + 10^(-snr/20)*crandn2(size(h));

    z = toep_trans(y, 'notransp');
    [nFilterLength, ~, ~] = size(z);

    cest = sum(abs(z).^2, 2);
    cest = reshape(cest, nFilterLength, nBatches);

    exps = est.W'*cest*est.rho + est.bias*nCoherence; % note cest sum not mean
    exps = exps - max(exps);

    weights = exp(exps);
    weights = weights./sum(weights);

    F = est.W*weights;
    F = reshape(F, nFilterLength, 1, nBatches);

    hest = toep_trans(F.*z, 'transp');
    errs = errs + sum(sum(abs(h - hest).^2))/trials/nBatches/nAntennas;

end




