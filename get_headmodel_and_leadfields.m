function [] = get_headmodel_and_leadfields()

% prepare headmodel and leadfield with fieldtrip for Colin27
SurfaceFiles = {'inputs/Colin27_tess_head.mat';...
    'inputs/Colin27_tess_outerskull.mat';...
    'inputs/Colin27_tess_innerskull.mat'};

ftGeometry = BS_to_ft_tess(SurfaceFiles);

load(['inputs/ft_channels_Colin27_channels_Montage_19'],'elec') % channel file

cfg = [];
cfg.method = 'openmeeg';
% cfg.elec   = ftElec;    % Sensor positions
cfg.conductivity = [0.33,0.004125,0.33];
% cfg.tissue = ['scalp','skull','brain'];
ftHeadmodel = ft_prepare_headmodel(cfg, ftGeometry);

save('inputs/ftHeadmodel_Colin27','ftHeadmodel') % headmodel

%% leadfields
load('inputs/sources_BS_order_66_Colin27','sources')

% Convert to a FieldTrip grid structure
ftGrid.pos    = sources.Loc;            % source points
ftGrid.inside = 1:size(sources.Loc,1);  % all source points are inside of the brain
ftGrid.unit   = 'm';

mon = {'Montage_256','Montage_128','Montage_64','Montage_32','Montage_19'};

for m = 1:length(mon)
    load(['inputs/ft_channels_Colin27_channels_' mon{m}],'elec') % channel file
    
    cfg = [];
    cfg.elec      = elec;
    cfg.grid      = ftGrid;
    cfg.headmodel = ftHeadmodel;  % Volume conduction model
    
    ftLeadfield = ft_prepare_leadfield(cfg);
    
    save(['inputs/ftLeadfield_BS_order_66_Colin27_channels_' mon{m}],'ftLeadfield')
end
end


