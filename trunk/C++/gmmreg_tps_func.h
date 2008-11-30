/*=========================================================================
$Date$
$Revision$
=========================================================================*/

/** 
 * \file gmmreg_tps_func.h
 * \brief  The declaration of the class gmmreg_tps_func
 */


#ifndef gmmreg_tps_func_h
#define gmmreg_tps_func_h

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
#include "gmmreg_base.h"
//#include "gmmreg_tps.h"

/** 
 * \class gmmreg_tps_func
 * \brief  the abstract base class for the L2/KC-based cost function
 */

class gmmreg_tps_func : public vnl_cost_function{

public:

    gmmreg_tps_func(): vnl_cost_function() {}

    virtual double eval(double&f1, double &f2, vnl_matrix<double> &g1, vnl_matrix<double> &g2) = 0;
    double f(const vnl_vector<double>& x);
    void gradf(const vnl_vector<double>& x, vnl_vector<double>& g);

    inline void set_scale(double scale){this->scale = scale;}
    inline void set_lambda(double lambda){this->lambda = lambda;}
    //inline void set_alpha(double alpha){this->alpha = alpha;}
    //inline void set_beta(double beta){this->beta = beta;}
    inline double get_scale(){return this->scale;}
    inline double get_lambda(){return this->lambda;}
    //inline double get_alpha(){return this->alpha;}
    //inline double get_beta(){return this->beta;}

    /*
    int set_init_affine(const char* filename);
    int set_init_tps(const char* filename);
    void set_param(vnl_vector<double>& x0);
    
    int set_init_params(const char* filename);
    void save_results(const char* f_config);



    void prepare_basis_kernel();
    void prepare_param_gradient(bool);
    void perform_transform();
    //vnl_matrix<double> param_affine, param_tps, basis, kernel;
    //vnl_matrix<double> model, scene, ctrl_pts, after_tps, param_all;
    */

    gmmreg_base* gmmreg;
    inline void set_gmmreg(gmmreg_base* gmmreg){
        this->gmmreg = gmmreg;
        this->m = gmmreg->m;
        this->n = gmmreg->n;
        this->d = gmmreg->d;
        gradient1.set_size(m,d);
        gradient2.set_size(m,d);
    }
    
    double scale, lambda; // alpha, beta;
    int m,n,d;

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

    vnl_matrix<double> gradient1, gradient2;


    //todo: virtual destructor
};

class gmmreg_tps_L2_func : public gmmreg_tps_func{
    double eval(double&f1, double &f2, vnl_matrix<double> &g1, vnl_matrix<double> &g2);
};


class gmmreg_tps_KC_func : public gmmreg_tps_func{
    double eval(double&f1, double &f2, vnl_matrix<double> &g1, vnl_matrix<double> &g2);
};

#endif //#ifndef vnl_gmmreg_tps_func_h_

