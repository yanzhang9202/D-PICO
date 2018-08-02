function [ weight_mat ] = geneDbStoch( n )
weight_mat = zeros(n, n);
M = zeros(n, n);
c = rand(n, 1);
c = c/sum(c);
for jj = 1 : n
    idx = randperm(n);
    idx = idx + (0:n-1)*n;
    M(idx) = M(idx) + c(jj);
end
% Check for connectivity
if norm(M - ones(n)/n) == 1
    error('ERROR: Possibly unconnected graph!')
end
weight_mat(:,:) = M;
end