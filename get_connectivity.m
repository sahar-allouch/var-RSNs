function cmat = get_connectivity(data, cfg)

% compute connectivity matrix
% inputs: data: nb_regions*nb_samples
%         srate: sampling frequency
%         fmin: lower limit of the frequency band
%         fmax: upper limit of the frequency band
%         conn: connectivity measure "PLV" or "wPLI"
% cmat: symmetric connectivity matrix, nb_regions*nb_regions
% 
% This code was originally developped by Sahar Allouch.
% contact: saharallouch@gmail.com



if cfg.conn_meth == "plv"
    %% plv
%     data = (ROInets.symmetric_orthogonalise(data'))';
    cmat = plv_sliding_window (data, cfg.srate, cfg.window, cfg.step);
  
elseif cfg.conn_meth == "pli"
    cmat = pli_sliding_window (data, cfg.srate, cfg.window, cfg.step);
    
elseif cfg.conn_meth == "wpli" || cfg.conn_meth == "wpli_debiased"
    %% wpli
    if cfg.conn_meth == "wpli_debiased"
        debiased = 1;
    else
        debiased = 0;
    end
    cmat = wpli_ft(data, cfg.srate, cfg.window, cfg.step, cfg.fmin, cfg.fmax, debiased);
    
elseif cfg.conn_meth == "aec"
    %% aec
    cmat = aec_sliding_window(data, cfg.srate, cfg.window, cfg.step);
    
elseif cfg.conn_meth == "aec_orth"
    %% aec corrected for source leakage via symmetric orthogonalization
    cmat = aec_sliding_window_corrected(data, cfg.srate, cfg.window, cfg.step);

end
end

