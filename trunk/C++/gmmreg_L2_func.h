/*=========================================================================
Program:   Pointset Registration using Gaussian Mixture Model
Module:    $RCSfile: gmmreg_L2_func.h,v $
Language:  C++
Author:    $Author: bjian $
Date:      $Date: 2008/06/05 17:06:21 $
Version:   $Revision: 1.1 $
=========================================================================*/

/** 
 * \file gmmreg_L2_func.h
 * \brief  The declaration of the class gmmreg_L2_func
 */


#ifndef gmmreg_L2_func_h
#define gmmreg_L2_func_h

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

/** 
 * \class gmmreg_L2_func
 * \brief  the abstract base class for the L2-based cost function
 */

class gmmreg_L2_func : public vnl_cost_function{

public:

	gmmreg_L2_func(): vnl_cost_function() {}

	virtual double f(const vnl_vector<double>& x) = 0;
	virtual void gradf(const vnl_vector<double>& x, vnl_vector<double>& g) = 0;

	inline void set_scale(double scale){this->scale = scale;}
	inline void set_alpha(double alpha){this->alpha = alpha;}
	inline void set_beta(double beta){this->beta = beta;}
	inline double get_scale(){return this->scale;}
	inline double get_alpha(){return this->alpha;}
	inline double get_beta(){return this->beta;}

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
	}
	
	double scale, alpha, beta;
	int m,n,d;

	//todo: virtual destructor
};



#endif //#ifndef vnl_gmmreg_tps_func_h_

