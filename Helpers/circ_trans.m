function y = circ_trans(x, tp)

if strcmp(tp, 'transp')
    y = ifft(x)*sqrt(size(x,1));
else
    y = fft(x)/sqrt(size(x,1));
end


