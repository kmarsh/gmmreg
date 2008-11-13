/*=========================================================================
$Author: bjian $
$Date: 2008/06/05 17:06:23 $
$Revision: 1.1 $
=========================================================================*/

/** 
 * \file gmmreg_L2_tps.h
 * \brief  The declaration of the class gmmreg_L2_tps
 */


#ifndef gmmreg_L2_tps_h
#define gmmreg_L2_tps_h

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
#include "gmmreg_L2_tps_func.h"

/** 
 * \class gmmreg_L2_tps
 * \brief  non-rigid registration by minimizing L2 distance and using TPS model
 */

class gmmreg_L2_tps : public gmmreg_base {

public:
	//vnl_gmmreg_tps_func(): vnl_gmmreg_func() {}



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
	void compute_gradient(double alpha, double beta, const vnl_matrix<double>& gradient, vnl_matrix<double>& grad_all);
	//vnl_matrix<double> param_affine, param_tps, basis, kernel;
	//vnl_matrix<double> model, scene, ctrl_pts, after_tps, param_all;

	vnl_matrix<double> param_affine, param_tps;
	std::vector<int> v_affine;
	int prepare_own_options(const char* f_config);

	gmmreg_L2_tps_func func;
	vnl_matrix<double> after_tps, basis, param_all;
	//bool fix_affine;

};



#endif //#ifndef gmmreg_L2_tps_h

