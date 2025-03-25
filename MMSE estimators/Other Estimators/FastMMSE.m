function est = FastMMSE(snr, c)

est = struct();
est.rho = 10^(0.1*snr);

w = c./(c + (1/est.rho));
est.v = fft(w);
est.bias = sum(log(1 - w));
