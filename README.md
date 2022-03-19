# anomres
Code and data required to generate the Figures presented in the paper "Direct Observations of Anomalous Resistivity and Diffusion in Collisionless Plasma" submitted to Nature Communications

# Abstract
Coulomb collisions provide plasma resistivity and diffusion but in many low-density astrophysical plasmas such collisions between particles are extremely rare. Here scattering of particles by electromagnetic waves can lower the plasma conductivity. Such anomalous resistivity due to wave-particle interactions could be crucial to many processes, including magnetic reconnection. It has been suggested that waves provide both diffusion and resistivity, which can support the reconnection electric field, but this requires direct observation to confirm. Here, we directly quantify anomalous resistivity, viscosity, and cross-field electron diffusion associated with lower hybrid waves using measurements from the four Magnetospheric Multiscale (MMS) spacecraft. We show that anomalous resistivity is approximately balanced by anomalous viscosity, and thus the waves do not contribute to the reconnection electric field. However, the waves do produce an anomalous electron drift and diffusion across the current layer associated with magnetic reconnection. This leads to relaxation of density gradients at timescales of order the ion cyclotron period, and hence modifies the reconnection process. 

# Running the scripts
The scripts require irfu-matlab (https://github.com/irfu/irfu-matlab) to be installed and the path set in Matlab. The data the scripts load should be moved to the same directory as the corresponding script. Scripts were run using irfu-matlab v1.16.0 (master branch). 

# Data
The data used for this study are publically available at https://lasp.colorado.edu/mms/sdc/public. 
For this study the following data products are used: 
For electric field: EDP, mms\#/edp/brst/l2/dce/...
For background magnetic field: FGM, mms\#/fgm/brst/l2/...
For fluctuating magnetic field: SCM, mms\#/scm/brst/l2/scb/...
For background electron moments: FPI, mms\#/fpi/brst/l2/des-moms/...
For high-resolution electrom moments: FPI, mms\#/fpi/brst/l2/des-qmoms/...
For high-resolution ion moments: FPI, mms\#/fpi/brst/l2/dis-qmoms/...


