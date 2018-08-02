graph_type = 2;     % 1 - doubly stochastic matrix, directed (not for C-ADMM)
                    % 2 - symm. doubly stoch. matrix, undirected
connt_type = 2;  % 0 - relative dense network
                % 1 - specify the number of edges
                % 2 - a chain (undirected)
                % 3 - a chain (directed)
switch graph_type
    case 1
    % Generate doubly stochastic matrix
    gph.wgt = geneDbStoch(data.N);
    gph.adj = AdjDS(gph.wgt);
    case 2
    % Generate doubly stochastic matrix based on a connected
    % undirected graph
    gph.adj = geneConnected(N, connt_type);
    gph.wgt = AdjDS(gph.adj); 
end

clear graph_type connt_type