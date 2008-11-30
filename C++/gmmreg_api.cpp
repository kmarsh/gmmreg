/*=========================================================================
$Date$
$Revision$
=========================================================================*/

/** 
 * \file gmmreg_api.cpp
 * \brief  The implementation of gmmreg_api interface
 */
#include <cstdlib>
#include <iostream>
#include <vector>
#include <memory>


#ifdef WIN32
#include <windows.h>
#else
#include "port_ini.h"
#endif

#include "gmmreg_api.h"
#include "gmmreg_cpd.h"
#include "gmmreg_tps.h"

typedef std::auto_ptr<gmmreg_cpd_tps> gmmreg_cpd_tps_Ptr;
typedef std::auto_ptr<gmmreg_cpd_grbf> gmmreg_cpd_grbf_Ptr;
typedef std::auto_ptr<gmmreg_tps_L2> gmmreg_tps_L2_Ptr;
typedef std::auto_ptr<gmmreg_tps_KC> gmmreg_tps_KC_Ptr;

extern "C"
int gmmreg_api(const char* input_config, const char* method)
{
    std::cout << "Nonrigid Point Set Registration" << std::endl;
    std::cout << "Compiled on " << __TIME__ << "," << __DATE__ << std::endl;
    std::cout << "Copyright 2008 Bing Jian & Baba C. Vemuri " << std::endl;
    char f_config[BUFSIZE];
    get_config_fullpath(input_config,f_config);
    vnl_vector<double> params;

    if (!strcmp(method, "cpd_tps"))
    {
        gmmreg_cpd_tps_Ptr gmmreg(new gmmreg_cpd_tps);
        gmmreg->initialize(f_config);
        gmmreg->start_registration(params);
        gmmreg->save_results(f_config,params);
    }
    else if (!strcmp(method, "cpd_grbf"))
    {
        gmmreg_cpd_grbf_Ptr gmmreg(new gmmreg_cpd_grbf);
        gmmreg->initialize(f_config);
        gmmreg->start_registration(params);
        gmmreg->save_results(f_config,params);
    }
    else if (!strcmp(method, "tps_L2"))
    {
        gmmreg_tps_L2_Ptr gmmreg(new gmmreg_tps_L2);
        gmmreg->initialize(f_config);
        gmmreg->start_registration(params);
        gmmreg->save_results(f_config,params);
    }
    else if (!strcmp(method, "tps_KC"))
    {
        gmmreg_tps_KC_Ptr gmmreg(new gmmreg_tps_KC);
        gmmreg->initialize(f_config);
        gmmreg->start_registration(params);
        gmmreg->save_results(f_config,params);
    }
    else
    {
        std::cerr << "Currently only four methods ('tps_L2','tps_KC', 'cpd_tps','cpd_grbf') are supported.";
        std::cerr << "Please type 'gmmreg_demo' with no argument for more information." << std::endl;
        return -1;
    }
    return 0;
}
