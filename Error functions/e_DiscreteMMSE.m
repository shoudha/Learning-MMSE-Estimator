function errs = e_DiscreteMMSE(nAntennas, snr, nBatches, trials, nCoherence, AS, nPaths)

nSamples = 16*nAntennas;

est = DiscreteMMSE(snr, nAntennas, nPaths, AS, nCoherence, 1, nSamples);

%Evaluate
errs = 0;

parfor bb = 1:trials
    
    [h, ~] = generate_channel(nAntennas, nPaths, AS, nCoherence, nBatches);
    y = h + 10^(-snr/20)*crandn2(size(h));

    nSamples   = length(est.W);

    % calculate weights for all batches
    exps = zeros(nSamples, nBatches);
    for b = 1:nBatches
        for t = 1:nCoherence
            for i = 1:nSamples
                exps(i, b) = exps(i, b) + real(y(:, t, b)'*est.W(:, :, i)*y(:, t, b))*est.rho + est.bias(i);
            end
        end
    end

    exps = exps - max(exps);
    weights = exp(exps);
    weights = weights./sum(weights);

    hest = zeros(nAntennas, nCoherence, nBatches);
    for b = 1:nBatches

        W_est = zeros(nAntennas, nAntennas);

        for i = 1:nSamples

            W_est = W_est + est.W(:, :, i)*weights(i, b);

        end

        hest(:, :, b) = W_est*y(:, :, b);

    end

    errs = errs + sum(sum(abs(h - hest).^2))/trials/nBatches/nAntennas;
    
end



