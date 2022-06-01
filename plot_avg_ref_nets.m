% AVERAGE AND PLOT REFERENCE NETWORKS
net = 'DAN';

conn = {'plv','aec','pli','aec_orth'};

for c = 1:length(conn)
    
    cmat_avg = zeros(200,66,66);
    k = 1;
    
    for s = 1:50
        for e = 1:4
            load([net '/cmats/Subject_' num2str(s) '\epoch_' num2str(e) '\cmat_ref_' conn{c} '.mat'])
            
            cmat_avg (k,:,:) = cmat_ref;
            k = k+1;
        end
    end
    
    cmat_avg = mean(cmat_avg,1);
    cmat_avg = reshape(cmat_avg(1,:,:),[66,66]);
    
    p = (6*5)/(66*65);
%     p = 0.01;
    cmat_avg_thre = threshold_proportional(cmat_avg,p);
    
    if exist(['BNV_imag/' net],'dir') ~= 7
        mkdir(['BNV_imag/' net])
    end
    
    plot_BNV(cmat_avg_thre,[net '/ref_' conn{c} '_thre_prop_exact'])
end

