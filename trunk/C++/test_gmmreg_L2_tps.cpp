/*=========================================================================
$Author$
$Date$
$Revision$
=========================================================================*/

/** 
 * \file test_gmmreg_L2_tps.cpp
 * \brief  testing the gmmreg L2 tps method
 */


#include <iostream>
#include "gmmreg_L2_tps_api.h"


int main(int argc, char* argv[])
{
    if (argc<2)
    {
        std::cerr << "Usage: " << argv[0] << " ConfigFile" << std::endl;
        return -1;
    }
    gmmreg_L2_tps_api(argv[1]);
    //  getchar();
    //  system("pause");
    return 0;
}


