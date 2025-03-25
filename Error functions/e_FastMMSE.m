function errs = e_FastMMSE(nAntennas, snr, nBatches, trials, nCoherence, AS, nPaths)

[~, t] = scm_channel(0.0, 1.0, nAntennas, nCoherence, AS);
c = real(best_circulant_approximation(t));

est = FastMMSE(snr, c);

%evaluate
errs = 0;

parfor bb = 1:trials

    [h, ~] = generate_channel(nAntennas, nPaths, AS, nCoherence, nBatches);
    y = h + 10^(-snr/20)*crandn2(size(h));

    y = fft(y)/sqrt(nAntennas);

    cest = mean(abs(y).^2, 2);
    cest = reshape(cest, nAntennas, nBatches);

    exps = real(ifft(conj(est.v).*fft(cest)))*est.rho*nCoherence + est.bias*nCoherence;
    exps = exps - max(exps);

    weights = exp(exps);
    weights = weights./sum(weights);

    F = real(ifft(est.v .* fft(weights)));
    F = reshape(F, nAntennas, 1, nBatches);

    x = F.*y;

    hest = ifft(x).*sqrt(nAntennas);
    errs = errs + sum(sum(abs(h - hest).^2))/trials/nBatches/nAntennas;

end



