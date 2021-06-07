# BRain: code dump for brain dynamics project

Repository for code used to generate figures in report for PHYS3888 ISP group, with supervisor A. Prof. Pulin Gong.

SIDs: 490379400, 490414549, 490378344, 490403912

## Brief description of included files

### Plotting files
* plot_prob_densities.m
  * Plots probability densities of gamma burst locations as in Sec. III B

### Functions
* prob_densities.m
  * Function processes xy.mat gamma burst position data to generate a grid of probabilities for gamma burst locations
* trainModel.py
  * Trains and tests algorithms and generates confusion matrices
  * Also evaluates and prints out the cross validation accuracy mean and standard deviation.
  * User needs to define the algorithm (modelkey) and feature data (datakey) combination as inputs to the trainModel function.
  * Note that scikit-learn version 0.24.1 was used to obtain our results.

### Data files
* d1_gamma_xy.mat, d2_gamma_xy.mat, d3_gamma_xy.mat, d4_gamma_xy.mat, spon_gamma_xy.mat,
  * Files with gamma burst centroid locations aggregated across 100 trials, 1000 ms after stimulus onset for each of the stimuli (D1, D2, D3, D4) + spontaneous period recordings respectively
* 15sd_500time_16res.mat,
  * Baseline feature matrix test (500 ms stim period, 1.5 SDs above mean, 16x16 grid)
* 15sd_1000time_16res.mat,   
  * Feature matrix tested with 1000 ms of stimulus period
* 25sd_500time_16res.mat,
  * Feature matrix with 2.5 SDs above mean
* 25sd_1000time_16res.mat,
  * Feature matrix with 1000 ms of stim period AND 2.5 SDs above mean
* 25sd_1000time_20res.mat,
  * Feature matrix with 2.5 SDs above mean, 1000 ms and 20 x 20 grid size
* 25sd_1000time_22res.mat,
  * As above but with higher resolution, 22 x 22 grid size
* 25sd_1000time_24res.mat,
  * Highest probability density map resolution tested, 24 x 24 grid size
* spont_25sd_1000time_20res.mat,
  * Control dataset with no stimulus.
