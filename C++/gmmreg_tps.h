/*=========================================================================
$Date$
$Revision$
=========================================================================*/

/** 
 * \file gmmreg_tps_L2.h
 * \brief  The declaration of the class gmmreg_tps_L2
 */


#ifndef gmmreg_tps_L2_h
#define gmmreg_tps_L2_h

#include <assert.h>

#include <iostream>
#include <fstream>

#include <vnl/vnl_matrix.h>
#include <vcl_string.h>    // string
#include <vnl/algo/vnl_matrix_inverse.h>
#include <vnl/algo/vnl_qr.h>
#include <vcl_iostream.h>
#include <vnl/vnl_cost_function.h>
#include <vnl/algo/vnl_lbfgs.h>
#include <vnl/vnl_trace.h>

#include "gmmreg_utils.h"
#include "gmmreg_base.h"
#include "gmmreg_tps_func.h"

/** 
 * \class gmmreg_tps_L2
 * \brief  non-rigid registration by minimizing L2 distance and using TPS model
 */

class gmmreg_tps: public gmmreg_base {

public:

    //gmmreg_tps(): gmmreg_base {}
    gmmreg_tps() {strcpy(section,"gmmreg_tps_L2_KC");}

    void start_registration(vnl_vector<double>&);
    int set_init_affine(const char* filename);
    int set_init_tps(const char* filename);
    void set_param(vnl_vector<double>& x0);
    void set_affine_and_tps(const vnl_vector<double>&);
    int set_init_params(const char* filename);
    void save_results(const char* f_config, const vnl_vector<double>&);

    void prepare_basis_kernel();
    void prepare_param_gradient(bool);
    void perform_transform(const vnl_vector<double>&);
    double bending_energy();
    void compute_gradient(double lambda, const vnl_matrix<double>& gradient, vnl_matrix<double>& grad_all);
    //vnl_matrix<double> param_affine, param_tps, basis, kernel;
    //vnl_matrix<double> model, scene, ctrl_pts, after_tps, param_all;

    vnl_matrix<double> param_affine, param_tps;
    std::vector<int> v_affine;
    int prepare_own_options(const char* f_config);

    gmmreg_tps_func *func;
    vnl_matrix<double> after_tps, basis, param_all;
    //bool fix_affine;

    inline void set_sigma(double sigma){this->sigma = sigma;}
    inline void set_lambda(double lambda){this->lambda = lambda;}
    //inline void set_alpha(double alpha){this->alpha = alpha;}
    //inline void set_beta(double beta){this->beta = beta;}
    inline double get_sigma(){return this->sigma;}
    //inline double get_alpha(){return this->alpha;}
    //inline double get_beta(){return this->beta;}
    inline double get_lambda(){return this->lambda;}

    unsigned int level;
    std::vector<double> v_scale, v_lambda;
    std::vector<int> v_func_evals;

    


};

class gmmreg_tps_L2: public gmmreg_tps {
public:
    gmmreg_tps_L2(): gmmreg_tps() {
        func = new gmmreg_tps_L2_func;
    }
    
};

class gmmreg_tps_KC: public gmmreg_tps {
public:
    gmmreg_tps_KC(): gmmreg_tps() {
        func = new gmmreg_tps_KC_func;
    }
};

#endif //#ifndef gmmreg_tps_L2_h

