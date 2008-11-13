/*=========================================================================
$Author$
$Date$
$Revision$
=========================================================================*/

/** 
 * \file test_gmmreg_cpd.cpp
 * \brief  testing the gmmreg_cpd method
 */


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


