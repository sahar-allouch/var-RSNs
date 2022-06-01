function EEG_data = additive_noise(EEG_signal,gamma)

EEG_signal = EEG_signal ./ norm(EEG_signal, 'fro');

% white sensor noise
[nb_channels,nb_samples] = size(EEG_signal);
EEG_channel_noise = randn(nb_channels,nb_samples);
EEG_channel_noise = EEG_channel_noise ./ norm(EEG_channel_noise, 'fro');
EEG_data = gamma*EEG_signal + (1-gamma)*EEG_channel_noise;


end

