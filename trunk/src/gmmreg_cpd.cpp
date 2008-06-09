/*=========================================================================
Program:   Pointset Registration using Gaussian Mixture Model
Module:    $RCSfile: gmmreg_cpd.cpp,v $
Language:  C++
Author:    $Author: bjian $
Date:      $Date: 2008/06/05 17:06:23 $
Version:   $Revision: 1.1 $
=========================================================================*/

#include "gmmreg_cpd.h"

void gmmreg_cpd::compute_P(const vnl_matrix<double>& x,const vnl_matrix<double>& y, vnl_matrix<double>& P, double &E, double sigma, int outliers)
{
	double k;
	k = -2*sigma*sigma;
    
    //P.set_size(m,n);P.fill(0);
	//vnl_vector<double> v_ij;
	column_sum.fill(0);
	for (int i=0;i<m;++i)
	{
		for (int j=0;j<s;++j)
		{
			double r = 0;
			for (int t=0;t<d;++t)
			{
				r += (x(i,t) - y(j,t))*(x(i,t) - y(j,t));
			}
			P(i,j) = exp(r/k);	
			column_sum[j]+=P(i,j);
		}
	}


	if (outliers!=0)
	{
		for (int i=0;i<s;++i)
			column_sum[i] += outlier_term;
	}
	if (column_sum.min_value()>(1e-12))
	{
		E = 0;
		for (int i=0;i<s;++i)
		{
			for (int j=0;j<m;++j){
				P(j,i) = P(j,i)/column_sum[i];
			}
			E-=log(column_sum[i]);
		}
		//vcl_cerr<<s;
		//vcl_cerr<<P.get_column(10);
	}
	else
	{
		P.empty();
	}
}


void gmmreg_cpd::start_registration(vnl_vector<double>& params)
{
	int iter = 0;
	vnl_matrix<double> P;
	double Eu,E_old;
	double E = 1;
    outlier_term = outliers*pow((2*sigma*sigma*3.1415926),0.5*d);
	double ntol = tol +10;
	vnl_matrix<double> dP;
	vnl_matrix<double> prev_model;
	vnl_matrix<double> moving_model(model);

			vnl_matrix<double> eye(n,n); 
			eye.set_identity();
			vnl_matrix<double> dPG;
			vnl_matrix<double> dPY0;

			dPG.set_size(m,m);
			dPY0.set_size(m,d);

			P.set_size(model.rows(),scene.rows());

	column_sum.set_size(s);
	while ((iter<max_it)&&(ntol>tol))
	{
		int EMiter = 0;
		EMtol = tol +10;
		prev_model = moving_model;
		while ((EMiter<max_it)&&(EMtol>tol))
		{		
			/*std::cout << "CPD iter="<<iter<< "\t";
			std::cout << "EMiter="<<EMiter<< "\t";
			std::cout << "E="<<E<<"\t";
			std::cout << "sigma="<<sigma<<std::endl;*/
			compute_P(moving_model, scene, P,Eu, sigma,outliers);

			//vcl_cerr<<P.get_column(10);
			
			if (P.empty())
			{	
				iter = max_it;
				break;
			}
			E_old = E;
		    double t = vnl_trace(param_all.transpose()*kernel*param_all);
			E = Eu + (lambda/2)*t;
			double row_sum;
			for (int i=0;i<m;++i)
			{
				row_sum  = P.get_row(i).sum();
				dPG.set_row(i, row_sum * kernel.get_row(i));
				dPY0.set_row(i, row_sum * model.get_row(i));
			}



			 vnl_qr<double> qr(dPG+lambda*sigma*sigma*eye); //, 1e-18);
			 //if (svd.singularities() > 1)
			 //	vcl_cerr << "Warning: Singular matrix, condition = " << svd.well_condition() << vcl_endl;
			 param_all = qr.solve(P*scene-dPY0);
			 //vcl_cout << kernel << vcl_endl;

			 //vcl_cerr<<W;
			moving_model = model + basis * param_all;
			EMtol = fabs(E_old-E)/E_old;
			EMiter++;
		}
		sigma *= anneal;
		
		iter ++;
		ntol = (moving_model - prev_model).array_two_norm();
	}
}

int gmmreg_cpd::set_init_params(const char* f_config)
{
	char f_init_params[80]={0};
	GetPrivateProfileString("Files", "init_params", NULL, f_init_params, 80, f_config);
    if (strlen(f_init_params)==0)
    {
		assert(n>0);
		assert(d>0);
		param_all.set_size(n,d);
		param_all.fill(0);
		return 0;
    }
    else
    {
		std::ifstream infile(f_init_params, std::ios_base::in);
		param_all.read_ascii(infile);
		assert(param_all.cols()==d);
		assert(param_all.rows()==n);
		return 1;
    }
}




void gmmreg_cpd::prepare_basis_kernel()
{
	ComputeGaussianKernel(model, ctrl_pts, basis, kernel, kappa);
}




void gmmreg_cpd::perform_transform(const vnl_vector<double> &x)
{
    transformed_model = model + basis*param_all;
}


double gmmreg_cpd::bending_energy()
{
	return vnl_trace(param_all.transpose()*kernel*param_all);
}

void gmmreg_cpd::compute_gradient(double alpha, double beta, const vnl_matrix<double>& gradient, vnl_matrix<double>& grad_all)
{
}


void gmmreg_cpd::save_results(const char* f_config, const vnl_vector<double>& params)
{
	char f_transformed[80]={0};
	GetPrivateProfileString("Files", "transformed_model", NULL, f_transformed, 80, f_config);
	save_transformed( f_transformed, params );

}

int gmmreg_cpd::prepare_own_options(const char* f_config)
{
	char s_EMtol[60]={0}, s_anneal[60]={0}, s_kappa[60]={0}, s_lambda[60]={0}, s_outliers[60]={0},s_sigma[60]={0},s_tol[60]={0},s_viz[60]={0};
	GetPrivateProfileString("Options", "emtol", NULL, s_EMtol, 60, f_config);
    EMtol = atof(s_EMtol);
	GetPrivateProfileString("Options", "anneal", NULL, s_anneal, 60, f_config);
	anneal = atof(s_anneal);
	GetPrivateProfileString("Options", "kappa", NULL, s_kappa, 60, f_config);
	kappa = atof(s_kappa);
	GetPrivateProfileString("Options", "lambda", NULL, s_lambda, 60, f_config);
	lambda = atof(s_lambda);
	GetPrivateProfileString("Options", "outliers", NULL, s_outliers, 60, f_config);
	outliers = atoi(s_outliers);
	GetPrivateProfileString("Options", "sigma", NULL, s_sigma, 60, f_config);
	sigma = atof(s_sigma);
	GetPrivateProfileString("Options", "tol", NULL, s_tol, 60, f_config);
	tol = atof(s_tol);
	max_it=GetPrivateProfileInt("Optimization", "max_it", 1, f_config);
	return 0;
}


