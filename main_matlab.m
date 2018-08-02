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
    
        [msol.x, msol.fval, msol.flagexit, msol.output, msol.lambda] = quadprog(...
            Hm, fm, [], [], Am, bm, lm, um, [], options);
        if msol.flagexit ~= 1
            error('Formulated problem cannot be exactly solved by Matlab!\n')
        end
        
        mdata.H = Hm;   mdata.f = fm;   mdata.A = Am;   mdata.b = bm;
        mdata.l = lm;   mdata.u = um;
        clear Qc Hm Ac Am fm bm lm um
    otherwise
        error('Undefined Matlab solution!')
end