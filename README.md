# var-RSNs
Along with the study of brain activity evoked by external stimuli, the past two decades witnessed an increased interest in characterizing the spontaneous brain activity occurring during resting conditions. The identification of the connectivity patterns in this so-called "resting-state" has been the subject of a great number of electrophysiology-based studies, using the Electro/Magneto-Encephalography (EEG/MEG) source connectivity method. However, no consensus has been reached yet regarding a unified (if possible) analysis pipeline, and several involved parameters and methods require cautious tuning. This is particularly challenging when different choices induce significant discrepancy in results and drawn conclusions, thereby hindering reproducibility of neuroimaging research. Hence, our objective in this study was to evaluate some of the parameters related to the EEG source connectivity analysis and shed light on their implications on the accuracy of the resulting networks. We simulated, using neural mass models, EEG data corresponding to two of the resting-state networks (RSNs), namely the default mode network (DMN) and the dorsal attentional network (DAN). We investigated how the correspondence between reconstructed and reference networks is affected by:
  1) five channel densities (19, 32, 64, 128, 256)
  2) three inverse solutions (weighted minimum norm estimate (wMNE), exact low resolution brain electromagnetic tomography (eLORETA), and linearly constrained minimum        variance (LCMV) beamforming) 
  3) four functional connectivity measures (phase-locking value (PLV), phase-lag index (PLI), and amplitude envelope correlation (AEC) with and without source leakage correction).
We believe that this work could be useful for the field of electrophysiology connectomics, by shedding light on the challenge of analytical variability and its consequences on the reproducibility of neuroimaging studies.

## Simulations
Simulations used in this study are available at https://doi.org/10.5281/zenodo.6597385. 
Cortical-level activity was generated using a flexible neural mass model framework, named COALIA. This multi-population neural mass model enables the simulation of brain-scale electrophysiological activity while accounting for the macro- (between regions) and micro-circuitry (within a single region) of the brain, with one neural mass representing the local field potential of one Desikan-Killiany atlas region [for details, readers may refer to (Bensaid et al. 2019)]. The simulated cortical networks (DMN and DAN) each included six regions based on the Desikan-Killiany atlas (Desikan et al. 2006) in terms of region parcellation. The DMN consisted of the right and left posterior cingulate cortex (PCC), medial orbitofrontal (MOF) gyrus, and inferior parietal lobe (IPL). Regarding the DAN, this network consisted of the right and left inferior parietal lobe (IPL), caudal middle frontal gyrus (cMFG), and superior parietal lobe (SPL). Activity in the alpha band ([8-12] Hz) was attributed to the regions belonging to reference RSNs, while background activity was assigned to remaining cortical regions. A variability between simulated data segments was introduced at the subject level, as well as at the level of epochs per subject. Each “virtual subject” had different connectivity matrices provided to the model, while each epoch for the same subject had a different input noise (mean =90, standard deviation = 30)  set within the model. More specifically, for each subject, a different fractional anisotropy matrix of the HCP dataset was used (Van Essen et al. 2013), and the weights corresponding to a RSN-connection were modified and set to a value of (1 ± 20%). A corresponding scaling of the matrices followed in accordance with COALIA’s requisites and the type of each input matrix (inhibitory/excitatory). A total of 50 “virtual subjects”, 4 epochs per subject (i.e., 200 data segments) were simulated; with a duration of 40 seconds each and a sampling rate of 2048 Hz. The time delay between NMMs was determined by the euclidean distance between the centroids of Desikan-Killainy’s regions divided by the velocity of action potentials propagation, which was set as 100 cm/s.

## Tested parameters:
  1) Channel densities: 19, 32, 64, 128, 256
  2) Inverse solutions:
      - weighted minimum norm estimate (wMNE)
      - exact low resolution brain electromagnetic tomography (eLORETA)
      - linearly constrained minimum variance (LCMV) beamforming
  4) Functional connectivity measures:
      - phase-locking value (PLV)
      - phase-lag index (PLI)
      - amplitude envelope correlation (AEC) without source leakage correction
      - amplitude envelope correlation (AEC) with source leakage correction (symmetric orthogonalization)

## Running the code:
- To obtain the connectivity matrices (for all conditions) of one epoch, you may run the function "run_one_epoch (s,e)". s (1-50) and e (1-4) are the subject and epoch ids.
- To obtain the connectivity matrices of all subjects and epochs (over all conditions), run "run_all_epochs()".
