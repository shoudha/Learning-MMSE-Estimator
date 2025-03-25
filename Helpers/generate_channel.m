function [h, t] = generate_channel(nAntennas, nPaths, AS, nCoherence, nBatches)

%scm.generate_channel
h = zeros(nAntennas, nCoherence, nBatches);
t = zeros(nAntennas, nBatches);

for trials = 1:nBatches
    
    %spectrum
    angles = (rand(1, nPaths) - 0.5)*180;
    gains = rand(1, nPaths);
    gains = gains./sum(gains);
    
    OF = 20;
    nFreqSamples = OF*nAntennas;

    x = 2*pi*(0:(nFreqSamples - 1))./nFreqSamples;
    x_rad = mod(x + pi, 2*pi) - pi;
    x_deg = 180*asin(x_rad/pi)./pi;

    weights = gains;
    
    v = laplace_custom(x_deg, angles, weights, AS);
    v = v + laplace_custom(180 - x_deg, angles, weights, AS);

    v = v .* (180/pi*2*pi./sqrt(pi^2 - x_rad.^2));
    
    %chan_from_spectrum
    % avoid instabilities due to almost infinite energy at some frequencies
    % (this should only happen at "endfire" of a uniform linear array where --
    % because of the arcsin-transform -- the angular psd grows to infinity
    % use nFreqSamples as threshold value...
    almostInfThreshold = max(1, nFreqSamples);
    almostInfFreqs = abs(v) > nFreqSamples;
    v(almostInfFreqs) = almostInfThreshold*angle(v(almostInfFreqs));

%     plot(v)
    if sum(v) > 0
        v = nFreqSamples*v./sum(v); % normalize energy
    end
    
    x = sqrt(0.5)*(randn(nFreqSamples, nCoherence) + sqrt(-1)*randn(nFreqSamples, nCoherence));    
    h1 = ifft(sqrt(v.').*x).*sqrt(nFreqSamples);
    h1 = h1(1:nAntennas, :);
    
    % t is the first row of the covariance matrix of h (which is Toeplitz and Hermitian)
    t1 = fft(v.')./nFreqSamples;
    t1 = t1(1:nAntennas);

    h(:, :, trials) = h1;
    t(:, trials) = t1;
    
end



