%% make plots to show results
do_lambda = 1;

%% plot the trajectory of lambda
% the lambda returned from matlab is thought as the true value
if do_lambda
    figure(101)
    subplot(1,2,1)
    hold on;
    num_itr = sol{2}.num_itr;
    plot(1:num_itr, sol{2}.lambda_itr(1:num_itr), 'b-');
    plot(1:num_itr, sol{1}.lambda.eqlin*ones(num_itr,1), 'r--')
    ax = gca;
    set(ax, 'FontSize', 15)
    set(ax, 'XLim', [1, num_itr*1.1])
    hold off;
    box on;
    subplot(1,2,2)
    dist = abs(sol{2}.lambda_itr(1:num_itr) - sol{1}.lambda.eqlin);
    plot(1:num_itr, dist);
    ax = gca;
    set(ax, 'YScale', 'log')
    set(ax, 'FontSize', 15)
    box on;

    print('plots/lambda_dd', '-depsc');

    clear dist ax
end
