/*=========================================================================
Program:   Pointset Registration using Gaussian Mixture Model
Module:    $RCSfile: gmmreg_L2_tps_func.cpp,v $
Language:  C++
Author:    $Author: bjian $
Date:      $Date: 2008/06/05 17:06:22 $
Version:   $Revision: 1.1 $
=========================================================================*/

#include "gmmreg_L2_tps_func.h"

double gmmreg_L2_tps_func::f(const vnl_vector<double>& x)
{
	
	gmmreg->perform_transform(x);
	double bending = gmmreg->bending_energy();
	vnl_matrix<double> gradient1, gradient2;
	gradient1.set_size(m,d);
	gradient2.set_size(m,d);
    double energy1 = GaussTransform(gmmreg->transformed_model, gmmreg->transformed_model, scale, gradient1);
    double energy2 = GaussTransform(gmmreg->transformed_model, gmmreg->scene, scale, gradient2);
    double	energy =  energy1 - 2* energy2;
	gradient = gradient1*2-gradient2*2;	
    energy = alpha*energy + beta*bending;
    return energy;
}

void gmmreg_L2_tps_func::gradf(const vnl_vector<double>& x, vnl_vector<double>& g)
{
	gmmreg->compute_gradient(alpha,beta,gradient,grad_all);
    int rows_x = grad_all.rows();
    int start_row = 0;
    if (fix_affine) // g does not include affine
    {
		start_row = d+1;
    }
    for (int i=start_row, k = 0; i<rows_x; ++i)
    {
		for (int j=0; j<d; ++j, ++k)
		{
			g[k] = grad_all(i,j);
		}
    }
}




void gmmreg_L2_tps_func::prepare_param_gradient()
{
    gradient.set_size(m,d);
    grad_all.set_size(n,d);
}





