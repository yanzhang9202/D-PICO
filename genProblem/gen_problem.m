%% Create problem data
switch pb_type
    case 'randQP'
        gen_randQP;    
    otherwise
        error('Undefined problem type!')        
end

%% Create graph
gen_graph;