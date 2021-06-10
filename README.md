# BRain: code dump for brain dynamics project

Repository for code used to generate figures in report for PHYS3888 ISP group, with supervisor A. Prof. Pulin Gong.

SIDs: 490379400, 490414549, 490378344, 490403912

## Brief description of included files

### Plotting files
* plot_zscorescentroids.m
  * Plots the zscores and centroids for the same GBP at two different times
* plot_onePattPlusTailFit.m
  * Plots one pattern from D1 stimulus and histogram of tail for D1 with loglog fit
* plot_avgTailDegree.m
  * Plots the averaged tail degree across all stimuli and all trials for different time windows
* plot_prob_densities.m
  * Plots probability densities of gamma burst locations as in Sec. III B

### Functions
* extractTailDeg.m
  * Processes a cell array of burst locations at different times to generate tail degrees for different time windows
* prob_densities.m
  * Function processes xy.mat gamma burst position data to generate a grid of probabilities for gamma burst locations
* trainModel.py
  * Trains and tests algorithms and generates confusion matrices
  * Also evaluates and prints out the cross validation accuracy mean and standard deviation.
  * User needs to define the algorithm (modelkey) and feature data (datakey) combination as inputs to the trainModel function.
  * We used Python 3.8.10 and key packages were scikit-learn 0.24.1, seaborn 0.11.1, matplotlib 3.3.4, numpy 1.19.2 and pandas 1.2.4. 
  * See requirements_conda.txt or requirements_pip.txt for a full list of dependencies. 
  * Use "conda create --name <env> --file requirements_conda.txt" to create the virtual Anaconda environment with your choice of name <env> OR
  * Use "pip install -r requirements_pip.txt" to install the required dependencies using pip.

### Data files
* somePatt_zscores_d1.mat
  * zscores for 10x10 grid at two different times arbitrarily chosen for D1, trial 1, corresponding to the same GBP. Also has xy and t data for corresponding pattern
* d1_jump_sizes.mat
  * Contains an array of centroid jump distances for D1 (collated across all trials)
* d1_timeWindowedLocs.mat, d2_timeWindowedLocs.mat, d3_timeWindowedLocs.mat, d4_timeWindowedLocs.mat
  * Give the gamma burst centroid locations NOT AGGREGATED for each direction
* d1_gamma_xy.mat, d2_gamma_xy.mat, d3_gamma_xy.mat, d4_gamma_xy.mat, spon_gamma_xy.mat,
  * Files with gamma burst centroid locations aggregated across 100 trials, 1000 ms after stimulus onset for each of the stimuli (D1, D2, D3, D4) + spontaneous period recordings respectively
* 15sd_500time_16res.mat,
  * Baseline feature matrix test (500 ms stimulus period, 1.5 SDs above mean, 16x16 grid)
* 15sd_1000time_16res.mat,   
  * Feature matrix tested with sampling from 1000 ms of stimulus period
* 25sd_500time_16res.mat,
  * Feature matrix with 2.5 SDs above mean threshold for gamma burst detection.
* 15sd_500time_20res.mat,
  * Feature matrix with 20x20 histogram bins for the gamma burst probability density maps.
* 25sd_1000time_16res.mat,
  * Feature matrix with 1000ms sampling from stimulus period and 2.5 SDs above mean threshold
* 25sd_1000time_20res.mat,
  * Feature matrix with 2.5 SDs above mean threshold, 1000ms sampling from stimulus period and 20x20 histogram bins.
* 25sd_1000time_22res.mat,
  * As above but with a higher resolution of 22x22 histogram bins.
* 25sd_1000time_24res.mat,
  * Highest probability density map resolution tested with 24x24 histogram bins.
* spont_25sd_1000time_20res.mat,
  * Control dataset with no stimulus, with the same parameters as the optimal feature matrix.
