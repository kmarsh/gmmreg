/*%%=====================================================================
%% Project:   Pointset Registration using Gaussian Mixture Model
%% Module:    $RCSfile: gmmreg_tps_mex.cpp,v $
%% Language:  C
%% Author:    $Author$
%% Date:      $Date$
%% Version:   $Revision$
%%=====================================================================*/


/** 
 * \file gmmreg_tps_mex.cpp
 * \brief  The MATLAB interface of calling gmmreg_L2_tps_api
 */


/* This mexFunction was written based on the Example: edit([matlabroot '/extern/examples/refbook/revord.c']); */

#include "gmmreg_L2_tps_api.h"
#include "mex.h"
#include "string.h"

/* #define MAXCHARS 80   /* max length of string contained in each field */


/*  the gateway routine.  */
void mexFunction(int nlhs,       mxArray *plhs[],
		 int nrhs, const mxArray *prhs[])
{
    /* Declare variables */ 
	char *f_config;
	
    
    /* Check for proper number of input and output arguments */    
    if (nrhs != 1) {
		mexErrMsgTxt("One input argument required.");
    } 
    else if (nlhs > 0){
		mexErrMsgTxt("No output argument.");
    }

	/* Check data type of input argument */
	/* input must be a string */
	if ( mxIsChar(prhs[0]) != 1)
	  mexErrMsgTxt("Input must be a string.");
	
	/* input must be a row vector */
	if (mxGetM(prhs[0])!=1)
	  mexErrMsgTxt("Input must be a row vector.");
    
   
	/* copy the string data from prhs[0] into a C string. */
	f_config = mxArrayToString(prhs[0]);
	
	if(f_config == NULL) 
	  mexErrMsgTxt("Could not convert input to string.");

	/* call the C subroutine */
	gmmreg_L2_tps_api(f_config);	

	/* no output, clean up */
	mxFree(f_config);
	return;
    
    
}
