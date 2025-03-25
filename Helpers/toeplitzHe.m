function C = toeplitzHe(t)

%scm.toeplitzHe
t_full = [conj(t(end:-1:2)); t(1:end)];

n = floor(length(t_full)/2) + 1;
C = zeros(n, n);
for i = 1:n
    for j = 1:n
        C(i, j) = t_full(j - i + n);
    end
end