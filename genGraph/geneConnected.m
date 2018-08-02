function [ mat ] = geneConnected( n, type )
switch type
    case 0
        num_edge = (n-1)*(n-2)/2+1;  % Guaranteed to be connected
    case 1
        num_edge = n;
end

% do_sparse = 1;
% if do_sparse
%     num_edge = 2*n;    
% else
%     num_edge = (n-1)*(n-2)/2+1;  % Guaranteed to be connected
% end
switch type
    case {0, 1}
        if num_edge < n-1
            error('Too few edges to generate connected graph!')
        else
            A = triu(ones(n), 1);
            ind = find(A);
            ind = ind(randperm(n*(n-1)/2));
            mat = zeros(n);
            mat(ind(1:num_edge)) = 1;
            mat = mat + mat' + eye(n);
            if num_edge < (n-1)*(n-2)/2+1   % Check connectivity
                flag = 0;
                tst = zeros(n);
                for ii = 1 : n
                    tst = tst * mat + mat;
                    if isempty(find(tst == 0))
                        flag = 1;
                        break;
                    end
                end
                if ~flag
                    error('Failed to generate connected graph!')
                end
            end    
        end
    case 2
        mat = zeros(n);
        for ii = 1 : n-1
            mat(ii, ii+1) = 1;
        end
        mat = mat + mat' + eye(n);
    case 3
        mat = zeros(n);
        for ii = 1 : n
            if ii < n
                mat(ii, ii+1) = 1;
            else
                mat(ii, 1) = 1;
            end
        end
        mat = mat + eye(n);        
end