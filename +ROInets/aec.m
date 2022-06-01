function c = aec(env)
	% Take in envelope timecourse and compute AEC
	%
	% INPUT
	% - env - envelope timecourse, n_times x n_signals 
	% === allouch: n_signals x n_times is the correct input format
	% 
	% OUTPUT
	% - c - AEC connectivity matrix
	%
	% EXAMPLE USAGE
	%
	% 	aec(env)
	%
	%
	% Romesh Abeysuriya 2017
	
	clean = all(isfinite(env),1);
	c = corr(env(:,clean).');
