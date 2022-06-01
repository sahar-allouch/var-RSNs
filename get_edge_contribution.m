function edge_contribution = get_edge_contribution(cmat_ref,cmat_est)

x = zscore(cmat_ref(:));
y = zscore(cmat_est(:));

% phi = edge-wise product vector 
phi = x.*y;

% normalization
% phi_n = (x.*y)./sum(x.*y);

edge_contribution = reshape(phi,[66,66]);
edge_contribution = edge_contribution .* (eye(66)==0);

% group_consistency = mean of phi over all subjects

end
