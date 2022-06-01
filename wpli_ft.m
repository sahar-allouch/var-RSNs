function wpli = wpli_ft(data,srate,window,step,fmin,fmax,debiased)

%%
% debiased = 1 --> debiased wPLI

%%
[nb_signals, nb_samples] = size(data);

elec.chanpos = zeros(nb_signals,3);
elec.elecpos = zeros(nb_signals,3);
elec.unit = 'm';
for i = 1:nb_signals
    elec.label(i,1) = {['S' num2str(i)]};
end

ftData.fsample = srate;
ftData.elec = elec;
ftData.label = elec.label';

%%
win_samples = ceil(window*srate);
nb_shifts  = ceil(step*srate);

mid_window = win_samples/2:nb_shifts:nb_samples-win_samples/2;
nb_windows = length(mid_window);

for i = 1:nb_windows
    ftData.time{i} =  0:1/srate:((win_samples/srate)-1/srate);
    ftData.trial{i} = data(:,1 + mid_window(i) - win_samples/2 : mid_window(i)+win_samples/2);
end

%% cross-spectrum
cfg = [];
cfg.method = 'mtmfft';
cfg.output = 'powandcsd';
cfg.taper = 'hanning';
cfg.foilim = [fmin,fmax];
cfg.pad = 'nextpow2';
cfg.keeptrials = 'yes';

% cfg.foi = 10;
% cfg.tapsmofrq = 2;

freq = ft_freqanalysis(cfg, ftData);

%% wpli
cfg = [];

if ~debiased
    cfg.method = 'wpli';
    conn_wpli = ft_connectivityanalysis(cfg,freq);
    conn_wpli = mean(abs(conn_wpli.wplispctrm),2);
%     conn_wpli = abs(mean(conn_wpli.wplispctrm,2));

elseif debiased
    cfg.method = 'wpli_debiased';
    conn_wpli = ft_connectivityanalysis(cfg,freq);
    conn_wpli = mean(conn_wpli.wpli_debiasedspctrm,2);
end

wpli = zeros(66,66);
for c = 1:65
    ids = 1:66-c;
    wpli (c+1:66,c) = conn_wpli(ids,1);
    conn_wpli(ids) = [];
end

wpli = wpli + wpli.';
% wpli = conn_wpli;
end


