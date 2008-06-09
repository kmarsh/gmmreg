/*=========================================================================
Program:   Pointset Registration using Gaussian Mixture Model
Module:    $RCSfile: test_gmmreg_cpd.cpp,v $
Language:  C++
Author:    $Author: bjian $
Date:      $Date: 2008/06/05 17:06:25 $
Version:   $Revision: 1.1 $
=========================================================================*/

#include <iostream>
#include "gmmreg_cpd_api.h"


int main(int argc, char* argv[])
{
	if (argc<2)
	{
		std::cerr << "Usage: " << argv[0] << " ConfigFile" << std::endl;
		return -1;
	}
	gmmreg_cpd_api(argv[1]);
	//  getchar();
	//  system("pause");
	return 0;
}


