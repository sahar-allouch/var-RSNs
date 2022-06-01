function [] = plot_BNV(cmat,outputFilename)

% plotting the networks using BrainNet Viewer (http://www.nitrc.org/projects/bnv/)
% Xia M, Wang J, He Y (2013) BrainNet Viewer: A Network Visualization Tool for Human Brain Connectomics. PLoS ONE 8: e68910.


% This code was originally developped by Sahar Allouch.
% contact: saharallouch@gmail.com

dlmwrite('inputs/BNV/PLV.edge',cmat, 'delimiter', '\t');

% surfaceFile = 'inputs/BNV/BrainMesh_ICBM152_smoothed.nv';
surfaceFile ='BrainMesh_ICBM152_smoothed.nv';
% surfaceFile = 'BrainMesh_Ch2_smoothed.nv';
% nodeFile = 'inputs/BNV/desikan_RR_LL_COALIAorder_labels.node';
nodeFile = 'inputs/BNV/desikan_L_R_BSorder_66.node';
edgeFile = 'inputs/BNV/PLV.edge';
% optionFile = 'inputs/BNV/opt_DMN_6_BS_new.mat';
optionFile = 'inputs/BNV/opt_DAN_6_BS_new.mat';


if exist('BNV_imag','dir') ~= 7
    mkdir('BNV_imag')
end

if nargin > 1
    outputFile = ['BNV_imag/' outputFilename '.png'];
    BrainNet_MapCfg(surfaceFile,nodeFile,edgeFile,optionFile,outputFile);
    
else
    BrainNet_MapCfg(surfaceFile,nodeFile,edgeFile,optionFile);
end
end

