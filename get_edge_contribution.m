function edge_contribution = get_edge_contribution(cmat_ref,cmat_est)

nb_rois = size(cmat_ref,1);

xx = cmat_ref(triu(true(nb_rois),1));
yy = cmat_est(triu(true(nb_rois),1));

x = zscore(xx(:));
y = zscore(yy(:));

% x = zscore(cmat_ref(:));
% y = zscore(cmat_est(:));

% phi = edge-wise product vector 
phi = x.*y;

% normalization
% phi_n = (x.*y)./sum(x.*y);

edge_contribution=triu(ones(66),1);
edge_contribution(edge_contribution==1) = phi;
edge_contribution = edge_contribution + edge_contribution';
% edge_contribution(triu(true(66),1)) = phi;
% edge_contribution = reshape(phi,[66,66]);
edge_contribution = edge_contribution .* (eye(66)==0);

% group_consistency = mean of phi over all subjects

end
