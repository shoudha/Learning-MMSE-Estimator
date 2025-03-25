function [yhat, L] = omp_genie_alg(A, y, y0)

k_max = 100;
B = A';

x = zeros(size(A, 2), size(y, 2));

yhat = zeros(size(y));
cost = sum(abs(y0 - yhat).^2);

L = [];
for k = 1:k_max

    cost_prev = cost;

    % Union of support sets
    L = [L, find_supp(B*(y - A*x))];
    % Restricted LS estimate
    x(L, :) = A(:, L)\y;
    ytmp = A*x;

    cost = sum(abs(y0 - ytmp).^2);
    if cost > cost_prev % cost increases...
        break
    end

    yhat(:) = ytmp(:);
    
end