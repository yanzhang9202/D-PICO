function [ x ] = locfun_dd(H, q, A, l, u, lambda)
    f = q + A'*lambda;
    options = optimoptions('quadprog',...
        'Algorithm','interior-point-convex','Display','off');        
    [x, ~, flagexit] = quadprog(...
            H, f, [], [], [], [], l, u, [], options);
    if flagexit ~= 1
        error('Local problem cannot be exactly solved by Matlab!\n')
    end    
end