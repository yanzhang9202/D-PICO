%% Create random QP problems
N = 10;  % number of the agents
n = 5;
m = 5;

% Generate data
Q = rand(n,n,N);
for ii = 1 : N
   Q(:,:,ii) = Q(:,:,ii)'*Q(:,:,ii);    % Make Qi matrices (semi)positive definite
   Q(:,:,ii) = 1/2*(Q(:,:,ii)' + Q(:,:,ii));
end
q = rand(n,N);
A = rand(m,n,N);
l = -ones(n, N);
u = ones(n, N);
