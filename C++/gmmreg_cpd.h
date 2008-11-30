/*=========================================================================
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
    
    gmmreg_cpd() {strcpy(section,"gmmreg_cpd_tps_grbf");}

    void start_registration(vnl_vector<double>&);
    //void compute_P(const vnl_matrix<double>& model,const vnl_matrix<double>& scene, vnl_matrix<double>& P, double &E, double sigma, int outliers);
    void set_param(vnl_vector<double>& x0);
    int set_init_params(const char* filename);
    void save_results(const char* f_config, const vnl_vector<double>&);

    void prepare_param_gradient(bool);
    void perform_transform(const vnl_vector<double>&);
    double bending_energy();
    void compute_gradient(double lambda, const vnl_matrix<double>& gradient, vnl_matrix<double>& grad_all);

    int prepare_own_options(const char* f_config);

    vnl_matrix<double> basis, param_all;
    double EMtol, tol, beta, anneal;
    int max_iter, max_em_iter, outliers;
    //vnl_vector<double> column_sum;
    //double outlier_term;

    virtual void prepare_basis_kernel() = 0;
    virtual double update_param() = 0;

    vnl_matrix<double> P;

};


class gmmreg_cpd_tps: public gmmreg_cpd {
public:
    vnl_matrix<double> tps;
    vnl_matrix<double> affine;
    void prepare_basis_kernel();
    double update_param();

    vnl_matrix<double> nP;
    vnl_matrix<double> G,Q1,Q2,R,invR;

};

class gmmreg_cpd_grbf: public gmmreg_cpd {
public:
    void prepare_basis_kernel();
    double update_param();

    vnl_matrix<double> dPG;
    vnl_matrix<double> dPY0;

    vnl_matrix<double> Gtranspose;

};


#endif //#ifndef gmmreg_cpd_h
