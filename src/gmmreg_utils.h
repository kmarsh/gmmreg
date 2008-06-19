/*=========================================================================
Program:   Pointset Registration using Gaussian Mixture Model
Module:    $RCSfile: gmmreg_utils.h,v $
Language:  C++
Author:    $Author: bjian $
Date:      $Date: 2008/06/05 17:06:24 $
Version:   $Revision: 1.1 $
=========================================================================*/

/** 
 * \file gmmreg_utils.h
 * \brief  The declaration of supporting functions
 */


#ifndef vnl_gmmreg_h_
#define vnl_gmmreg_h_

#include <vnl/vnl_vector.h>
#include <vnl/vnl_matrix.h>
#include <vector>

#ifdef WIN32
#include <windows.h>
#endif

#define BUFSIZE 4096

double GaussTransform(const vnl_matrix<double>& A, const vnl_matrix<double>& B, double scale);
double GaussTransform(const vnl_matrix<double>& A, const vnl_matrix<double>& B, double scale, vnl_matrix<double>& gradient);
//double GaussTransform(const vnl_matrix<double>& A, const vnl_matrix<double>& B, double scale, double* gradient);
//double GaussTransform(const double* A, const double* B, int m, int n, int dim, double scale, double* grad);
void ComputeTPSKernel(const vnl_matrix<double>& model, const vnl_matrix<double>& ctrl_pts, vnl_matrix<double>& U, vnl_matrix<double>& K);
void ComputeGaussianKernel(const vnl_matrix<double>& model, const vnl_matrix<double>& ctrl_pts, vnl_matrix<double>& G, vnl_matrix<double>& K, double beta);
void parse_tokens(char* str, const char delims[], std::vector<double>& v_tokens);
void parse_tokens(char* str, const char delims[], std::vector<int>& v_tokens);
void find_working_pair(const vnl_matrix<double>&M, const vnl_matrix<double>&S,
					   const vnl_matrix<double>&Transformed_M, const double threshold,
					   vnl_matrix<double>&working_M, vnl_matrix<double>&working_S);
int get_config_fullpath(const char* input_config,char* f_config);
void save_matrix( const char * filename, const vnl_matrix<double>& x);

//void normalize(const vnl_matrix<double>& x, vnl_vector<double>& centroid, double& scale, vnl_matrix<double>& normalized_x);
//void denormalize(const vnl_matrix<double>& x, const vnl_vector<double>& centroid, const double scale, vnl_matrix<double>& denormalized_x);
void normalize(vnl_matrix<double>& x, vnl_vector<double>& centroid, double& scale);
void denormalize(vnl_matrix<double>& x, const vnl_vector<double>& centroid, const double scale);

#endif //#ifndef vnl_gmmreg_h_
