function [filters] = get_inverse_solution(eeg,srate,inv_meth,montage,noiseCov)

% compute EEG inverse solution using eLORETA and wMNE
% inputs: eeg: nb_channels*nb_samples
% srate: sampling rate
% montage: montage based on which EEG data was computed. {'EGI_HydroCel_256',
% 'EGI_HydroCel_128','EGI_HydroCel_64','EGI_HydroCel_32','10-20_19'}.

% Outputs: filters: nb_regions*nb_channels, nb_regions denotes the number
% of cortical sources, nb_channels denotes the number of EEG channels.

% This code was originally developped by Sahar Allouch.
% contact: saharallouch@gmail.com

%%
load('inputs/sources_BS_order_66_Colin27','sources') % sources location and orientation
load(['inputs/ft_channels_Colin27_channels_' montage],'elec') % channel file
load('inputs/ftHeadmodel_Colin27','ftHeadmodel') % headmodel
load(['inputs/ftLeadfield_BS_order_66_Colin27_channels_' montage],'ftLeadfield') % leadfield

%%

epoch_length = size(eeg,2)/srate;
filters = [];

ftData.trial{1} = eeg;
ftData.time{1}  = 0:1/srate:epoch_length-1/srate;
ftData.elec = elec;
ftData.label = elec.label';
ftData.fsample = srate;
clear eeg


if inv_meth == "eloreta"
    %% eLORETA
    cfg                      = [];
    cfg.covariance           = 'yes';
    cfg.covariancewindow     = 'all';
    cfg.keeptrials           = 'no';    %if 'yes' no avg field in the output struct
    timelock                 = ft_timelockanalysis(cfg,ftData);
    
    cfg                     = [];
    cfg.method              = 'eloreta';
    cfg.sourcemodel         = ftLeadfield;
    cfg.sourcemodel.mom     = transpose(sources.Orient);
    cfg.headmodel           = ftHeadmodel;
    cfg.eloreta.keepfilter  = 'yes';
    cfg.eloreta.keepmom     = 'no';
    cfg.eloreta.lambda      = 0.05; % default in ft = 0.05 (used before 0.01)
    src                     = ft_sourceanalysis(cfg,timelock);
    
    filters(:,:)            = cell2mat(transpose(src.avg.filter));
    
elseif inv_meth == "wmne"
    %% wMNE
    weightExp = 0.5;
    weightLimit = 10;
    SNR = 3;
    
    Gain=cell2mat(ftLeadfield.leadfield);
    GridLoc = sources.Loc;
    GridOrient = sources.Orient;
    
    filters(:,:) = inverse.ComputeWMNE(noiseCov,Gain,GridLoc,GridOrient,weightExp,weightLimit,SNR);
elseif inv_meth == "lcmv"
    %% LCMV Beamformer
    % data covariance matrix
    cfg                      = [];
    cfg.covariance           = 'yes';
    cfg.covariancewindow     = 'all';
    cfg.keeptrials           = 'no';    %if 'yes' no avg field in the output struct
    timelock                 = ft_timelockanalysis(cfg,ftData);
    
    
    % Generate Beamformer weights
    cfg                      = [];
    cfg.method               = 'lcmv';
    cfg.sourcemodel          = ftLeadfield;
    cfg.sourcemodel.mom      = transpose(sources.Orient);
    cfg.headmodel            = ftHeadmodel;
    cfg.lcmv.fixedori        = 'no';
    cfg.lcmv.keepfilter      = 'yes';
    cfg.lcmv.keepmom         = 'no';
    cfg.keepleadfield        = 'no';
    cfg.lcmv.lambda          = '5%'; % 1%';   % '5%'    '10%'   '15%'   '20%'    '25%'
    
    cfg.lcmv.projectnoise    = 'no';
%     cfg.lcmv.weightnorm      = 'unitnoisegain';
    
    src                      = ft_sourceanalysis(cfg,timelock);
    
    filters(:,:)            = cell2mat(src.avg.filter);

end
end
