##=====================================================================
## $RCSfile: readme.txt,v $
## $Author: bjian $
## $Date: 2008/06/28 23:45:57 $
## $Revision: 1.3 $
##=====================================================================

This directory contains the MATLAB code for the robust point-set
registration algorithm proposed in the ICCV'05 paper:

"Bing Jian and Baba C. Vemuri, 
A Robust Algorithm for Point Set Registration Using Mixture of Gaussians."


It is a part of software package which can be freely downloaded from
http://www.cise.ufl.edu/research/cvgmi/Software.php#gmmreg


Files in this "MATLAB" directory are organized as follows:

MATLAB/  

	gmmreg_demo.m
	    A Matlab test script of the C++ implementation.
	    See http://www.cise.ufl.edu/research/cvgmi/Software.php#gmmreg

	gmmreg_L2.m
	    The main entry for the MATLAB implementation.

	initialize_config.m
	    Generate the configuration struct used in gmmreg_L2.m
	
	GaussTransform/
	    MEX-files for implementing the GaussTransform

	registration/
	    Functions used in the Matlab implementation of the GMMReg algorithm, 
	    requiring 'GaussTransform' and the optimization toolbox.

	auxiliary/
	    Some supporting functions, mostly for displaying the results.
		

Use 'addpath(genpath(pwd))' to add the "MATLAB" directory 
and its subdirectories to the MATLAB search path.

If you have any questions, please contact bing.jian@gmail.com
	


     
    	