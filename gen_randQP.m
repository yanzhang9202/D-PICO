%% Create random QP problems
N = 5;  % number of the agents
n = 2;
m = 1;

% Generate data
Q = zeros(n,n,N);
q = zeros(n,N);
A = zeros(m,n,N);
