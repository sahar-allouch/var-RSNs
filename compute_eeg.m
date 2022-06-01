function eeg = compute_eeg(simulated_sources, montage)

% EEG direct problem
% Compute scalp EEG from cortical sources
%
% inputs: simulated_sources: cortical level sources, nb_regions*nb_samples,
% montage: name of the electrode montage based on which EEG data will be
% generated {'EGI_HydroCel_256','EGI_HydroCel_128','EGI_HydroCel_64',
% 'EGI_HydroCel_32','10-20_19'}


% This code was originally developped by Sahar Allouch.
% contact: saharallouch@gmail.com

%%
% load leadfield struct
load(['inputs/ftLeadfield_BS_order_66_Colin27_channels_' montage],'ftLeadfield')

% load sources struct, sources.Orient = orientations of the sources
load('inputs/sources_BS_order_66_Colin27','sources')
source_Orient = transpose(sources.Orient);

m = split(montage,'_');
leadfields_const = zeros(str2double(m{2}),66);

% constrain the orientation of the sources to the normal to the surface
for i=1:66
    leadfields_const(:,i) = ftLeadfield.leadfield{i}*source_Orient(:,i);
end

% compute eeg
eeg = leadfields_const*simulated_sources;

% if exist('inputs','dir') ~= 7
%     mkdir('inputs')
% end
% save(['inputs/EEG_' montage],'eeg')

end