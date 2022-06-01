% AVERAGE AND PLOT RESONCTRUCTED NETWORKS

net =  'DAN';

conn = {'plv','aec','pli','aec_orth'};
inv = {'wmne','eloreta','lcmv'};
montage = {'256','128','64','32','19'};
gamma = '1';

for m = 1:length(montage)
    for c = 1:length(conn)
        
        if strcmp(conn{c},'aec_orth') && ismember(montage{m},{'19','32','64'})
            continue
        end
        
        for i = 1:length(inv)
            
            cmat_avg = zeros(200,66,66);
            k = 1;
            
            for s = 1:50
                for e = 1:4
                    load([net '/cmats/Subject_' num2str(s) '/epoch_' num2str(e) '/cmat_est_' conn{c} '_' inv{i} '_Montage_' montage{m} '_gamma_' gamma '.mat'])
                    
                    cmat_avg (k,:,:) = cmat_est;
                    k = k+1;
                end
            end
            
            cmat_avg = mean(cmat_avg,1);
            cmat_avg = reshape(cmat_avg(1,:,:),[66,66]);
            
            p = (6*5)/(66*65);
            p = 0.01;
            cmat_avg_thre = threshold_proportional(cmat_avg,p);
            
            if exist(['BNV_imag/' net],'dir') ~= 7
                mkdir(['BNV_imag/' net])
            end
            
            plot_BNV(cmat_avg_thre,[net '/est_' conn{c} '_' inv{i} '_Montage_' montage{m} '_gamma_1_thre_prop_exact'])
        
        end
    end
end
