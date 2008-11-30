/*=========================================================================
$Date$
$Revision$
=========================================================================*/

/** 
 * \file gmmreg_demo.cpp
 * \brief  testing the gmmreg method
 */


#include <iostream>
#include "gmmreg_api.h"


int main(int argc, char* argv[])
{
    if (argc<3)
    {
        std::cerr << "Usage: " << argv[0] << " configfile method" << std::endl;
        std::cerr << "The following four methods are currently available:" << std::endl;
        std::cerr << " 'cpd_tps': Haili Chui and Anand Rangarajan,\
A new point matching algorithm for non-rigid registration, \
Computer Vision and Image Understanding, 2003, 89(2-3), pp. 114-141." << std::endl;
        std::cerr << " 'cpd_grbf': Andriy Myronenko, Xubo B. Song, Miguel A. Carreira-Perpinan,\
Non-rigid Point Set Registration: Coherent Point Drift,\
NIPS 2006, pp. 1009-1016." << std::endl;
        std::cerr << " 'tps_L2': Bing Jian and Baba C. Vemuri,\
A Robust Algorithm for Point Set Registration Using Mixture of Gaussians,\
ICCV 2005, pp. 1246-1251." << std::endl;
        std::cerr << " 'tps_KC': Yanghai Tsin and Takeo Kanade, \
A Correlation-Based Approach to Robust Point Set Registration, \
ECCV (3) 2004: 558-569. " << std::endl;
        return -1;
    }
    gmmreg_api(argv[1], argv[2]);
    return 0;
}


