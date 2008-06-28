##=====================================================================
## $RCSfile: DisplayPoints2D.m,v $
## $Author: bjian $
## $Date: 2008/01/06 07:00:57 $
## $Revision: 1.3 $
##=====================================================================


Files in the "MATLAB" directory are organized as follows:

MATLAB/  

	gmmreg_demo.m
	    A Matlab test script of the C++ implementation

	GMMReg.m
		The main entry for the MATLAB implementation of rigid registration

	GMMReg_TPS.m
		The main entry for the MATLAB implementation of non-rigid registration using thin-plate splines
	
	GaussTransform/
	    MEX-files for implementing the GaussTransform

	registration/
	    Functions used in the Matlab implementation of the GMMReg algorithm, 
	    requiring 'GaussTransform' and the optimization toolbox.

	auxiliary/
	    Some supporting functions for displaying the results
		

The command 'addpath(genpath(pwd))' at the "MATLAB" directory will add all above functions
to MATLAB search path.
	


     
    	