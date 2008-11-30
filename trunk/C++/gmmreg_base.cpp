/*=========================================================================
$Date$
$Revision$
=========================================================================*/

/** 
 * \file gmmreg_base.cpp
 * \brief  The definition of the base class
 */


#include "gmmreg_base.h"

int gmmreg_base::initialize(const char* f_config)
{
    if (prepare_input(f_config)<0)
    {
        return -1;
    }
    set_init_params(f_config);
    prepare_common_options(f_config);
    prepare_own_options(f_config);
    prepare_basis_kernel();
    return 0;
}

int gmmreg_base::prepare_input(const char* f_config)
{
    char f_model[80]={0}, f_scene[80]={0}, f_ctrl_pts[80]={0};
    //char f_init_params[80]={0};

    GetPrivateProfileString("Common", "model", NULL, f_model, 80, f_config);
    if (set_model(f_model)<0)
    {
        return -1;
    }
    
    GetPrivateProfileString("Common", "scene", NULL, f_scene, 80, f_config);
    if (set_scene(f_scene)<0)
    {
        return -1;
    }

    GetPrivateProfileString("Common", "ctrl_pts", NULL, f_ctrl_pts, 80, f_config);
    if (set_ctrl_pts(f_ctrl_pts)<0)	
    {
        //todo: compute the ctrl pts on the fly
        return -1;
    }

    return 0;
}


// load model point set
int gmmreg_base::set_model(const char* filename)
{
    std::ifstream infile(filename, std::ios_base::in);
    if (infile.is_open())
    {
        if (model.read_ascii(infile))
        {
            m = model.rows();
            d = model.cols();
            transformed_model.set_size(m,d);
            return m;
        }
        else{
            std::cerr << "unable to parse input file " << filename << " as a matrix." <<std::endl;
            return -1;
        }
    }
    else
    {
        std::cerr << "unable to open model file " << filename << std::endl;
        return -1;
    }
}

// load scene point set
int gmmreg_base::set_scene(const char* filename)
{
    std::ifstream infile(filename, std::ios_base::in);
    if (infile.is_open()){
        if(scene.read_ascii(infile)){
            s = scene.rows();
            assert(scene.cols()==d);
            return s;
        }else{
            std::cerr << "unable to parse input file " << filename << " as a matrix." <<std::endl;
            return -1;
        }
    }
    else
    {
        std::cerr << "unable to open scene file " << filename << std::endl;
        return -1;
    }

}

int gmmreg_base::set_ctrl_pts(const char* filename)
{
    if (strlen(filename)==0)
    {
        std::cout << "The control point set is not specified, the model points are used as control points." << std::endl;
        ctrl_pts = model;
        n = ctrl_pts.rows();
        return n;
    }
    else
    {
        std::ifstream infile(filename, std::ios_base::in);
        if (infile.is_open()){
            ctrl_pts.read_ascii(infile);
            assert(ctrl_pts.cols()==d);
            n = ctrl_pts.rows();
            return n;
        }
        else
        {
            std::cerr << "unable to open control points file " << filename << std::endl;
            return -1;
        }
    }
}


void gmmreg_base::save_transformed( const char * filename, const vnl_vector<double>& params)
{
    std::ofstream outfile(filename,std::ios_base::out);
    perform_transform(params);
    if (b_normalize)
        denormalize(transformed_model,scene_centroid, scene_scale);
    transformed_model.print(outfile);
    std::cout<<"Please find the transformed model set in "<<filename<<std::endl;
}




int gmmreg_base::prepare_common_options(const char* f_config)
{
    b_normalize = GetPrivateProfileInt("Common", "normalize", 1, f_config);
    if (b_normalize)
    {
        normalize(model,model_centroid,model_scale);
        normalize(scene,scene_centroid,scene_scale);
        normalize(ctrl_pts,model_centroid,model_scale);
    }
    return 0;
}
