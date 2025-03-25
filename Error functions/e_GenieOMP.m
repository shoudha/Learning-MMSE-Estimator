function errs = e_GenieOMP(nAntennas, snr, nBatches, trials, nCoherence, AS, nPaths)

%evaluate
errs = 0;

parfor bb = 1:trials

    [h, ~] = generate_channel(nAntennas, nPaths, AS, nCoherence, nBatches);
    y = h + 10^(-snr/20)*crandn2(size(h));

    nGrid = 4*nAntennas; % four times oversampled DFT
    grid = linspace(-1, 1, nGrid + 1);
    grid = grid(1:nGrid);
    A = (1/sqrt(nAntennas))*exp(sqrt(-1)*pi*(0:nAntennas - 1)'*grid);

    hest = zeros(size(h));
    for b = 1:nBatches

        [yhat, ~] = omp_genie_alg(A, y(:, :, b), h(:, :, b));
        hest(:, :, b) = yhat;

    end

    errs = errs + sum(sum(abs(h - hest).^2))/trials/nBatches/nAntennas;

end
