function [] = run_all_epochs()
srate = 2048;
trim = 1;
fmin = 8;
fmax = 12;

% gamma = 0.7; %(gamma = [0.5,1]; 1 = no noise)
net = 'DMN';
path = ['data/' net];

for  s = 10:11
    for e = 2:2
        
        % read the data
        load([path '/Subject_' num2str(s) '/epoch_' num2str(e) '.mat'],'data');
        
        % trim the first second of the simulations (model unstability)
        data(:,1:trim*srate) = [];
        
        % remove DC offset
        data = remove_DC_offset(data);
        
        % normalize signals
        data = data./max(data,[],2);
        
        % bandpass filter
        data_filtered = bst_bandpass_filtfilt(data,srate,fmin,fmax);
        
        %         conn_measures = {'plv','aec', 'pli', 'wpli', 'wpli_debiased','aec_orth'};
        %         conn_measures = {'plv', 'pli', 'wpli', 'wpli_debiased', 'aec', 'aec_orth'};
        conn = {'plv','aec','aec_orth','pli'};
        
        for c = 3:length(conn)
            
            % get connectivity matrix
            cfg = [];
            cfg.srate = srate;
            cfg.fmin = fmin;
            cfg.fmax = fmax;
            cfg.conn_meth = conn{c};
            
            switch c
                case 1
                    cfg.window = 6/(fmin+(fmax-fmin)/2); % 6 cycles
                    cfg.step = cfg.window;  % no overlap
                case 2
                    cfg.window = 6; % 6 sec
                    cfg.step = 0.5; % 0.5 sec
                case 3
                    cfg.window = 6; % 6 sec
                    cfg.step = 0.5; % 0.5 sec
                case 4
                    cfg.window = 6/(fmin+(fmax-fmin)/2); % 6 cycles
                    cfg.step = cfg.window;  % no overlap
            end
            
            % get connectivity matrix
            cmat_ref = get_connectivity(data_filtered,cfg);
            
            if exist([net '/cmats/Subject_' num2str(s)  '/epoch_' num2str(e)],'dir') ~= 7
                mkdir([net '/cmats/Subject_' num2str(s) '/epoch_' num2str(e)])
            end
            
            save([net '/cmats/Subject_' num2str(s)  '/epoch_' num2str(e) '/cmat_ref_' conn{c} '.mat'],'cmat_ref')
            
            %%
            mon = {'Montage_256','Montage_128','Montage_64','Montage_32','Montage_19'};
            inv = {'wmne','eloreta','lcmv'};
            
            for m = 1:length(mon)
                
                if strcmp(conn{c},'aec_orth') && ismember(mon{m},{'Montage_64','Montage_32','Montage_19'})
                    continue
                end
                
                for iv = 1:length(inv)
                    
                    
                    % compute scalp EEG
                    eeg = compute_eeg(data,mon{m});
                    
                    %                     gamma = [0.9,0.8,0.7,0.6,0.5,0.4,0.3,0.2,0.1];
                    gamma = [1];
                    for g = 1:length(gamma)
                        % add scalp EEG noise
                        eeg = additive_noise(eeg,gamma(g)); %(gamma = [0.5,1]; 1 = no noise)
                        
                        % identity noise covariance marix == no noise modeling ==
                        % assuming equal, unit variance of noise on every sensor ==
                        % assuming the noise homoskedastic and equivalent on all
                        % sensors (if data quality is not even on all electrodes, a
                        % higher noise level on some sensors may be explained with
                        % stroger, spurious, source activity
                        
                        nb_elec = size(eeg,1);
                        noiseCov = eye(nb_elec);
                        % noiseCov = inverse.CalculateNoiseCovarianceTimeWindow(eeg);
                        
                        % solving the inverse problem
                        filters = get_inverse_solution(eeg,srate,inv{iv},mon{m},noiseCov);
                        
                        est_data = filters * eeg;
                        
                        % bandpass filter
                        est_data = bst_bandpass_filtfilt(est_data,srate,fmin,fmax);
                        
                        % get connectivity matrix
                        cmat_est = get_connectivity(est_data,cfg);
                        
                        if exist([net '/cmats/Subject_' num2str(s) '/epoch_' num2str(e)],'dir') ~= 7
                            mkdir([net '/cmats/Subject_' num2str(s) '/epoch_' num2str(e)])
                        end
                        
                        save([net '/cmats/Subject_' num2str(s)  '/epoch_' num2str(e) '/cmat_est_' conn{c} '_' inv{iv} '_' mon{m} '_gamma_' num2str(gamma(g)) '.mat'],'cmat_est')
                        
                    end
                end
            end
        end
    end
end
