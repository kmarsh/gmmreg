/*=========================================================================
Program:   Pointset Registration using Gaussian Mixture Model
Module:    $RCSfile: gmmreg_cpd_api.cpp,v $
Language:  C++
Author:    $Author: bjian $
Date:      $Date: 2008/06/05 17:06:23 $
Version:   $Revision: 1.1 $
=========================================================================*/

/** 
 * \file gmmreg_cpd_api.cpp
 * \brief  The implementation of gmmreg_cpd_api interface
 */

#include <iostream>
#include <vector>

#ifdef WIN32
#include <windows.h>
#else
#include "port_ini.h"
#endif

#include "gmmreg_cpd_api.h"
#include "gmmreg_cpd.h"

extern "C"
int gmmreg_cpd_api(const char* input_config)
{
	std::cout << "Nonrigid Point Set Registration Using Mixture of Gaussians" << std::endl;
	std::cout << "Compiled on " << __TIME__ << "," << __DATE__ << std::endl;
	std::cout << "(C) Copyright 2008, Bing Jian and Baba C. Vemuri" << std::endl;
	char f_config[BUFSIZE];
	get_config_fullpath(input_config,f_config);

	vnl_vector<double> params;
	gmmreg_cpd gmmreg;
	gmmreg.initialize(f_config);
	gmmreg.start_registration(params);
	gmmreg.save_results(f_config,params);
	return 0;

}
