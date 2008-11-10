/*=========================================================================
Program:   Pointset Registration using Gaussian Mixture Model
Module:    $RCSfile: gmmreg_base.h,v $
Language:  C++
Author:    $Author: bjian $
Date:      $Date: 2008/06/05 17:06:23 $
Version:   $Revision: 1.1 $
=========================================================================*/

/** 
 * \file gmmreg_base.h
 * \brief  The declaration of the base class
 */


#ifndef gmmreg_base_h
#define gmmreg_base_h

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

#ifdef WIN32
#include <windows.h>
#else
#include "port_ini.h"
#endif

#include "gmmreg_utils.h"


/** 
 * \class gmmreg_base
 * \brief  the base class
 */
class gmmreg_base{


public:
    gmmreg_base(){}

    virtual void perform_transform(const vnl_vector<double>&) = 0;
    virtual double bending_energy() = 0;
    virtual void compute_gradient(double alpha, double beta, const vnl_matrix<double>& gradient, vnl_matrix<double>& grad_all) = 0;
    virtual int prepare_own_options(const char* f_config) = 0;
    virtual void prepare_basis_kernel() = 0;
    virtual int set_init_params(const char* filename) = 0;
    virtual void save_results(const char* filename, const vnl_vector<double>&) = 0;

    int initialize(const char* f_config);
    int prepare_input(const char* input_config);
    int set_model(const char* filename);
    int set_scene(const char* filename);
    int set_ctrl_pts(const char* filename);
    void save_transformed(const char* filename, const vnl_vector<double>&);

    //void prepare_basis_kernel();
    //void prepare_param_gradient(bool);

    inline void set_scale(double scale){this->scale = scale;}
    inline void set_alpha(double alpha){this->alpha = alpha;}
    inline void set_beta(double beta){this->beta = beta;}
    inline double get_scale(){return this->scale;}
    inline double get_alpha(){return this->alpha;}
    inline double get_beta(){return this->beta;}

    vnl_matrix<double> basis, kernel;
    vnl_matrix<double> model, scene, ctrl_pts, transformed_model, param_all;
    vnl_vector<double> model_centroid, scene_centroid;
    double model_scale, scene_scale;


    int level;
    int b_normalize;
    std::vector<double> v_scale, v_alpha, v_beta;
    std::vector<int> v_func_evals;
    int prepare_common_options(const char* f_config);

//protected:
    /* param_affine, basis, kronBasis, kernel, scene, scale, alpha, beta, d */
    double scale, alpha, beta;
    /* m: points in model */
    /* s: points in scene */
    /* n: points in ctrl_pts */
    /* d: dimensionality  2D or 3D */
    /* Each Row is a Sample Point */
    int m,n,s,d,dim;

    vnl_matrix<double> gradient, grad_all;  
};


#endif //#ifndef gmmreg_base_h
