function closeness_accuracy = get_closeness_accuracy(cmat_ref,cmat_est)


% average node euclidean distance
load('inputs\Colin27_euclidean_distance_mat_desikan_66.mat','distance_mat_66')

tmp_ref = (cmat_ref>0);
tmp_est = (cmat_est>0);

nodes_ref = find((sum(tmp_ref,1)>0)==1);
nodes_est = find((sum(tmp_est,1)>0)==1);

dd = distance_mat_66(nodes_est, nodes_ref);
d = min(dd,[],2); % '*10' to convert cm to mm

results.avgDist = sum(d)/length(nodes_est);

% closeness accuracy
closeness_accuracy = 1/(1+results.avgDist);

end