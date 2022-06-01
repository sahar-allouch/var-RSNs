function [] = get_results_quantif()
% results quantification
clear all

mont        =   {'Montage_256','Montage_128','Montage_64','Montage_32','Montage_19'};
inv         =   {'wmne','eloreta','lcmv'};
conn        =   {'plv','aec','aec_orth','pli'};

% gamma       =   [1,0.9,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1];
gamma       =   [1];


nb_subj     =   50;
nb_epochs   =   4;

nets = {'DMN','DAN'};

for n = 1:1%length(nets)
    for g = 1:length(gamma)
        
        % loop over all subjects
        for s = 1:nb_subj
            
            % loop over all epochs of each subject
            for e = 1:nb_epochs
                
                % loop over connectivity measures
                for c = 1:length(conn)
                    
                    % load ref connectivity matrices
                    load([nets{n} '/cmats/Subject_' num2str(s)  '/epoch_' num2str(e) '/cmat_ref_' conn{c}],'cmat_ref')
                    
                    % loop over electrodes configurations
                    for m = 1:1%length(mont)
                        
                        % condition set because aec_orth does not exists
                        % for 19, 32 and 64 electrodes
                        if strcmp(conn{c},'aec_orth') && ismember(mont{m},{'Montage_19','Montage_32','Montage_64'})
                            continue
                        end
                        
                        % loop over inverse methods
                        for iv = 1:length(inv)
                            
                            % load reconstructed network
                            load([nets{n} '/cmats/Subject_' num2str(s)  '/epoch_' num2str(e) '/cmat_est_' conn{c} '_' inv{iv} '_' mont{m} '_gamma_' num2str(gamma(g)) '.mat'],'cmat_est')
                            
                            % pearson correlation
                            corr_mat = corrcoef(cmat_ref,cmat_est);
                            results.pearson_correlation = corr_mat(1,2);
                            
                            %                         % threshold based on strength values
                            %                         nb_sources = size(cmat_ref,1);
                            %                         p = 6;
                            %                         p = p/nb_sources; % = 0.09 = 0.090909090909091
                            %                         cmat_ref_thre = threshold_strength(cmat_ref,p);
                            %                         cmat_est_thre = threshold_strength(cmat_est,p);
                            
                            
                            % proportional threshold
                            p = (6*5)/(66*65); % keep only 30 edges == nb of edges in the reference network.
%                             p = 0.01;
                            cmat_ref_thre = threshold_proportional(cmat_ref,p);
                            cmat_est_thre = threshold_proportional(cmat_est,p);
                            
%                             % pearson correlation after thresholding the
%                             % connectivity matrices
%                             corr_mat = corrcoef(cmat_ref_thre,cmat_est_thre);
%                             results.pearson_correlation = corr_mat(1,2);
                            
                            % closeness acccuracy
                            results.closeness_accuracy = get_closeness_accuracy(cmat_ref_thre,cmat_est_thre);
                            
                            % edge contribution
                            tmp = get_edge_contribution(cmat_ref,cmat_est);
                            results.edge_contribution = tmp;
                            
                            if exist([nets{n} '/results/Subject_' num2str(s)  '/epoch_' num2str(e)],'dir') ~= 7
                                mkdir([nets{n} '/results/Subject_' num2str(s) '/epoch_' num2str(e)])
                            end
                            
                            save([nets{n} '/results/Subject_' num2str(s)  '/epoch_' num2str(e) '/results_' conn{c} '_' inv{iv} '_' mont{m} '_gamma_' num2str(gamma(g)) '.mat'],'results');
                        end
                    end
                end
            end
        end
    end
end

get_mean_edge_contribution()

end
