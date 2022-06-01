function pli = pli_sliding_window(data,srate,window,step)

[nb_signals, nb_samples] = size(data);

win_samples = ceil(window*srate);
nb_shifts  = ceil(step*srate);

mid_window = win_samples/2:nb_shifts:nb_samples-win_samples/2;
nb_windows = length(mid_window);


inst_phase = zeros(nb_signals,nb_samples);
for i = 1:nb_signals
    inst_phase(i, :) = angle(hilbert((data(i, :))));
end

%% dynamic pli
pli = zeros(nb_windows,nb_signals,nb_signals);

for i = 1:nb_windows
    tmp = inst_phase(:,1 + mid_window(i) - win_samples/2 : mid_window(i)+win_samples/2);
    pli(i,:,:) = ROInets.pli(tmp);
end

%% static pli
pli = mean(pli,1);
pli = reshape(pli(1,:,:),[nb_signals,nb_signals]);

end
