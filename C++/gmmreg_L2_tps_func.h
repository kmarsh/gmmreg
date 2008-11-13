/*=========================================================================
$Author$
$Date$
$Revision$
=========================================================================*/

/** 
 * \file gmmreg_L2_tps_func.h
 * \brief  The declaration of the class gmmreg_L2_tps_func
 */


#ifndef vnl_gmmreg_tps_func_h_
#define vnl_gmmreg_tps_func_h_

#include <assert.h>

#include <iostream>
#include <fstream>

#include <vnl/vnl_matrix.h>
#include <vcl_string.h>    // string
#include <vnl/algo/vnl_matrix_inverse.h>
#include <vcl_iostream.h>
#include <vnl/vnl_cost_function.h>
#include <vnl/algo/vnl_lbfgs.h>
#include <vnl/vnl_trace.h>

#include "gmmreg_utils.h"
#include "gmmreg_L2_func.h"
//#include "gmmreg_L2_tps.h"

/** 
 * \class gmmreg_L2_tps_func
 * \brief  the class for the L2-based cost function using TPS model
 */

class gmmreg_L2_tps_func : public gmmreg_L2_func{

public:

    double f(const vnl_vector<double>& x);
    void gradf(const vnl_vector<double>& x, vnl_vector<double>& g);
    //void set_affine_and_tps(const vnl_vector<double>&);
    void prepare_param_gradient();
    bool fix_affine;

    inline void set_fix_affine(bool fix_affine){
        this->fix_affine = fix_affine;
        if (fix_affine)
        {
            dim = (n-d-1)*d;
        }
        else
        {
            dim = n*d;
        }
        gmmreg->dim = dim;
        //(gmmreg_L2_tps*)gmmreg->fix_affine = fix_affine;
    }
    inline bool get_fix_affine(){return this->fix_affine;}
    /*
    int set_init_affine(const char* filename);
    int set_init_tps(const char* filename);
    
    
    int set_init_params(const char* filename);
    void save_results(const char* f_config);



    void prepare_basis_kernel();
    
    void perform_transform();
    */
    //vnl_matrix<double> param_affine, param_tps, basis, kernel;
    //vnl_matrix<double> model, scene, after_tps, param_all;
    vnl_matrix<double> gradient, grad_all;


};



#endif //#ifndef vnl_gmmreg_tps_func_h_

