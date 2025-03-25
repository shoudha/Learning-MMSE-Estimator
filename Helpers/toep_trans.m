function y = toep_trans(x, tp)

if strcmp(tp, 'transp')
    temp = ifft(x);
    y = temp(1:(end/2), :, :)*sqrt(size(x,1));
    if length(size(x)) == 2
        y = y(:, :, 1);
    end
else
	y = fft([x;zeros(size(x))])/sqrt(2*size(x,1));
end

