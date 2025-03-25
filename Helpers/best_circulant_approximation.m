function c = best_circulant_approximation(t)

n = length(t);
lins = ((n:-2:(-n + 2))./n);
t1 = t;
t2 = [1; conj(t(end:-1:2))];
c = 0.5*n*real(ifft(lins'.*(t1 - t2) + t1 + t2));