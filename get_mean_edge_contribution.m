function [] = get_mean_edge_contribution()
%% mean edge contribution across all subjects and trials
clear all

mont    =   {'Montage_256','Montage_128','Montage_64','Montage_32','Montage_19'};
inv     =   {'eloreta','lcmv','wmne'};
conn    =   {'plv','aec','pli','aec_orth'};

gamma   = [1];
g       = 1;

nets = {'DMN','DAN'};

nb_subj     = 50;
nb_epochs   = 4;

for n = 1:length(nets)
    
    % loop over connectivity measures
    for c = 1:length(conn)
        
        % loop over electrode configurations
        for m = 1:length(mont)
            
            % condition set because aec_orth does not exists
            % for 19, 32 and 64 electrodes
            if strcmp(conn{c},'aec_orth') && ismember(mont{m},{'Montage_19','Montage_32','Montage_64'})
                continue
            end
            
            % loop over inverse solutions
            for iv = 1:length(inv)
                
                mean_edge_contribution = zeros(66);
                
                % loop over all subjects
                for s = 1:nb_subj
                    
                    % loop over all epochs of each subject
                    for e = 1:nb_epochs
                        
                        % load edge contribution/results
                        load([nets{n} '/results/Subject_' num2str(s)  '/epoch_' num2str(e) '/results_' conn{c} '_' inv{iv} '_' mont{m} '_gamma_' num2str(gamma(g)) '.mat'],'results');
                        
                        mean_edge_contribution = (mean_edge_contribution+results.edge_contribution);
                        
                    end
                end
                
                % mean across all subjects and all epochs
                mean_edge_contribution = mean_edge_contribution./(s*e);
                
                % resting state edges' contribution
                if strcmp(nets{n},'DMN')
                    rsn = [15,16,27,28,45,46]; % nodes in dmn
                else
                    rsn = [5,6,15,16,57,58];
                end
                rsn_mean_edge_contribution = mean_edge_contribution(rsn,rsn);
                
                % threshold mean edge contribution - Keep highest 1%
                % contributions only
                p = (6*5)/(66*65);
                mean_edge_contribution = threshold_proportional(mean_edge_contribution,p);
                
                if exist([nets{n} '/results/mean_edge_contribution'],'dir') ~= 7
                    mkdir([nets{n} '/results/mean_edge_contribution'])
                end
                
                save([nets{n} '/results/mean_edge_contribution/RSN_mean_edge_contribution_' conn{c} '_' inv{iv} '_' mont{m} '_gamma_' num2str(gamma(g)) '.mat'],'rsn_mean_edge_contribution');
                save([nets{n} '/results/mean_edge_contribution/mean_edge_contribution_' conn{c} '_' inv{iv} '_' mont{m} '_gamma_' num2str(gamma(g)) '_thre_prop_exact.mat'],'mean_edge_contribution');
            end
        end
    end
end
end