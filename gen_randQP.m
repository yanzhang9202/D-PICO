%% Create random QP problems
N = 5;  % number of the agents
n = 2;
m = 1;

% Generate data
Q = rand(n,n,N);
q = rand(n,N);
A = rand(m,n,N);
