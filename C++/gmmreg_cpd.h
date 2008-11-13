/*=========================================================================
$Author$
$Date$
$Revision$
=========================================================================*/

/** 
 * \file gmmreg_cpd.h
 * \brief  The declaration of the class gmmreg_cpd
 */


#ifndef gmmreg_cpd_h
#define gmmreg_cpd_h

#include <assert.h>

#include <iostream>
#include <fstream>

#include <vnl/vnl_matrix.h>
#include <vcl_string.h>    // string
#include <vnl/algo/vnl_qr.h>
#include <vcl_iostream.h>
#include <vnl/vnl_trace.h>

#include "gmmreg_utils.h"
#include "gmmreg_base.h"

/** 
 * \class gmmreg_cpd
 * \brief  non-rigid registration by coherent point drifting
 */

class gmmreg_cpd : public gmmreg_base {

public:
    //vnl_gmmreg_tps_func(): vnl_gmmreg_func() {}

    void start_registration(vnl_vector<double>&);
    void compute_P(const vnl_matrix<double>& model,const vnl_matrix<double>& scene, vnl_matrix<double>& P, double &E, double sigma, int outliers);
    void set_param(vnl_vector<double>& x0);
    int set_init_params(const char* filename);
    void save_results(const char* f_config, const vnl_vector<double>&);

    void prepare_basis_kernel();
    void prepare_param_gradient(bool);
    void perform_transform(const vnl_vector<double>&);
    double bending_energy();
    void compute_gradient(double alpha, double beta, const vnl_matrix<double>& gradient, vnl_matrix<double>& grad_all);

    int prepare_own_options(const char* f_config);

    vnl_matrix<double> basis, param_all;
    double EMtol, tol, kappa, lambda, anneal, sigma;
    int max_it, outliers;
    vnl_vector<double> column_sum;
    double outlier_term;

};


#endif //#ifndef gmmreg_cpd_h
