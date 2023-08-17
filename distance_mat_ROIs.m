load('inputs/Colin27_scout_Desikan-Killiany_68.mat','Scouts');
load('inputs/Colin27_tess_cortex_pial_low.mat','Vertices');

seed_points = [Scouts.Seed];
nb_rois = length(seed_points);
distance_mat = zeros(nb_rois,nb_rois);

for i=1:nb_rois
    for j=1:nb_rois
        % distance from seed to seed
        distance_mat(i,j) = vecnorm(Vertices(seed_points(i),:)-Vertices(seed_points(j),:));
    end
end


% remove left insula L and right insula cz they does not exist in the
% simulation model, remove row #19 and #20 according to BS desikan
distance_mat (:,19) = [];
distance_mat (:,19) = [];
distance_mat (19,:) = [];
distance_mat (19,:) = [];

% change the order of the ROI so they match the order used in the
% simulation model
distance_mat_66 = zeros(66,66);

for i = 1:66
    for j = 1:66
        if mod(i,2)==0 && mod(j,2)==0
            distance_mat_66 (i/2,j/2) = distance_mat(i,j);
%             label_i {i/2,1} = Scouts(i).Label;
%             label_j {1,j/2} = Scouts(j).Label;
        elseif mod(i,2)~=0 && mod(j,2)~=0
            distance_mat_66(34+floor(i/2),34+floor(j/2))= distance_mat(i,j);
%             label_i {34+floor(i/2),1} = Scouts(i).Label;
%             label_j {1,34+floor(j/2)} = Scouts(j).Label;
        elseif mod(i,2)==0 && mod(j,2)~=0
            distance_mat_66(i/2,34+floor(j/2))= distance_mat(i,j);
%             label_i {(i/2),1} = Scouts(i).Label;
%             label_j {1,34+floor(j/2)} = Scouts(j).Label;
        elseif mod(i,2)~=0 && mod(j,2)==0
            distance_mat_66(34+floor(i/2),j/2)= distance_mat(i,j);
%             label_i {34+floor(i/2),1} = Scouts(i).Label;
%             label_j {1,j/2} = Scouts(j).Label;
        end
    end
end

% convert from m(BS) to cm(COALIA)
distance_mat_66 = distance_mat_66*100;
save ('inputs/Colin27_euclidean_distance_mat_desikan_66','distance_mat_66');

distance_mat_67 = [zeros(66,1),distance_mat_66];
distance_mat_67 = [zeros(1,67);distance_mat_67];
save ('inputs/Colin27_euclidean_distance_mat_desikan_67','distance_mat_67');

c = 100;
delay_mat_67 = distance_mat_67./c;
save ('inputs/Colin27_delay_mat_desikan_67','delay_mat_67');
% 