%% Create random QP problems
N = 5;  % number of the agents
n = 2;
m = 1;

% Generate data
Q = rand(n,n,N);
for ii = 1 : N
   Q(:,:,ii) = Q(:,:,ii)'*Q(:,:,ii);    % Make Qi matrices (semi)positive definite
end
q = rand(n,N);
A = rand(m,n,N);
l = -ones(n, N);
u = ones(n, N);
