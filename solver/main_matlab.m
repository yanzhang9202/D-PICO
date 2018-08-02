%% Using matlab solver to solve the problem
switch pb_type
    case 'randQP'
        options = optimoptions('quadprog',...
        'Algorithm','interior-point-convex','Display','off');
    
        Qc = num2cell(Q, [1,2]);
        Hm = blkdiag(Qc{:});
        fm = q(:);        
        Ac = num2cell(A, [1,2]);
        Am = horzcat(Ac{:});
        bm = zeros(size(Am,1),1);
        um = u(:);  lm = l(:);
    
        [solm.x, solm.fval, solm.flagexit, solm.output, solm.lambda] = quadprog(...
            Hm, fm, [], [], Am, bm, lm, um, [], options);
        if solm.flagexit ~= 1
            error('Formulated problem cannot be exactly solved by Matlab!\n')
        end
        
        datam.H = Hm;   datam.f = fm;   datam.A = Am;   datam.b = bm;
        datam.l = lm;   datam.u = um;
        clear Qc Hm Ac Am fm bm lm um
    otherwise
        error('Undefined Matlab solution!')
end