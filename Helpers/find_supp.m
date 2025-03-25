function L = find_supp(x)


x = sum(abs(x).^2, 2);
x = x(:);

[~, ind] = sort(x, 'descend');
L = ind(1);

