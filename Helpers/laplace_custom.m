function v = laplace_custom(x_deg, angles, weights, AS)

v = 0.0;
for i = 1:length(weights)
    xshifted = x_deg - angles(i);
    xshifted = mod(xshifted + 180, 360) - 180;
    v = v + (weights(i)/(2*AS))*exp(-abs(xshifted)/AS);
end
