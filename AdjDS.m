% This function computes a doubly stochastic matrix on an undirected graph 
function [ output ] = AdjDS( mtx )
if nnz((mtx < 1).*(mtx > 0)) == 0  % No entries are between 0 and 1, adjacency matrix
    deg = sum(mtx, 1);  % Degree of each node
    N = size(mtx, 1);   % Size of the network
    output = zeros(N);
    for i = 1 : N
       ind = find(mtx(i,:));
       for j = ind
           if j ~= i
           output(i,j) = 1/max(deg([i,j]));
           end
       end
       output(i,i) = 1 - sum(output(i,:));
    end
else
    output = find(mtx > 0);
end
end