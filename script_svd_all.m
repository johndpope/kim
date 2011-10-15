s_subj={
    'skeri0001'
     'skeri0004'
     'skeri0009'
     'skeri0017'
     'skeri0035'
     'skeri0037'
    %% 'skeri0039'
     %'skeri0044'
     %'skeri0048'
     %'skeri0050'
     %'skeri0051'
     %'skeri0053'
     %'skeri0054'
     %'skeri0060'
     %'skeri0066'
     %'skeri0069'
     %'skeri0071'
     %'skeri0072'
     %'skeri0075'
     %'skeri0076'
     %'skeri0078'
     %'skeri0081'
    };

% load ./mat/svd_stat;
svd_stat = [];
t_svd = [];
save ./mat/svd_stat svd_stat t_svd;
for i_sub = 1:numel(s_subj)
    subj_id = s_subj{i_sub};
    load ./mat/svd_stat
    n_spokes    = 4;
    n_rings     = 4;
    n_patch = n_spokes*n_rings;
    noise_level = 0;
    a_source_accounted = [1 2];
    
    
    fprintf('\n %s \n\n\n\n', subj_id);
    run('analyze_src')
    load ./mat/svd_stat
    run('script_svd')
    saveas(1, fullfile('out', 'fig', subj_id), 'png')
    svd_stat(i_sub).corr_VC = corr_VC;
    svd_stat(i_sub).corr_VCTF = corr_VCTF;
    svd_stat(i_sub).id = subj_id;
    save svd_stat svd_stat t_svd
end

load ./mat/svd_stat
svd_stat_all = reshape([svd_stat.corr_VC],3, numel([svd_stat.corr_VC])/3)';
tt_svd = t_svd;
figure(1010); clf(1010);
for i=1:numel(t_svd)
    signs = sign(svd_stat(i).corr_VC);
    tt_svd{i}(:,1) = t_svd{i}(:,1)*signs(1);
    tt_svd{i}(:,2) = t_svd{i}(:,2)*signs(2);
    tt_svd{i}(:,3) = t_svd{i}(:,3)*signs(3);
    plot(tt_svd{i}(:,1), 'b'); hold on;
    plot(tt_svd{i}(:,2)+1, 'g');
    plot(tt_svd{i}(:,3)+2, 'r');
end
plot(V{1}*.5+0, 'k', 'LineWidth', 5)
plot(V{2}*.5+1, 'k', 'LineWidth', 5)
plot(V{3}*.15+2, 'k', 'LineWidth', 5)

%dp = dot_prod_1;
%c_pair = {[1 1], [2 2], [3 3], [1 2], [1 3], [2 3]}; 
%for i=1:6, 
	%for j=1:numel(s_subj), 
		%c1 = c_pair{i}(1); 
	%	c2 = c_pair{i}(2); 
	%	cp(j,i) = dp(j,i)/sqrt(dp(j,c1)*dp(j,c2)); 
%	end;
%end;



svd_stat_all1= reshape([svd_stat.corr_VC],3, numel([svd_stat.corr_VC])/3)';
svd_stat_all2 = reshape([svd_stat.corr_VCTF],2, numel([svd_stat.corr_VC])/3)';
%%
noise_level = 0;
n_source_acc = 2;
title_str = sprintf('%gX%g : noise= %g : source_{acc}= %g', n_spokes, n_rings, noise_level, n_source_acc);
filename_str = sprintf('./pic/%gX%g_noise=%g_source_{acc}=%g_ratio322_jitter_norm_down_1-60-120elec', n_spokes, n_rings, noise_level, n_source_acc);

figure(1011); clf(1011);
subplot(1,2,1)
plot(abs(svd_stat_all1))
title('corr(SVD, V_{true})')
xlabel('subject id'), ylabel('corr')
ylim([-1 1])
text(1,-.7, title_str);
subplot(1,2,2)
plot(abs(svd_stat_all2))
title('corr(SVD, V_{true})')
xlabel('subject id'), ylabel('corr')
ylim([-1 1])
saveas(1011, filename_str, 'png')

eval_str = sprintf('scp -r "%s.png" c:/raid/pic/', filename_str);
system(eval_str)

%%
%try, clf(120), end; figure(120); 
% bar(roi_area(:,1), 'FaceColor', [0 0 1]); hold on;
% bar(roi_area(:,2), 'FaceColor', [.2 .6 .3]);
% bar(roi_area(:,3), 'FaceColor', [.9 .2 0]);
% stem(roi_area, 'o', 'MarkerSize', 8, 'MarkerFaceColor', 'auto');
% xlim([-3 25]);