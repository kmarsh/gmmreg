#!/usr/bin/env python
#coding=utf-8

##====================================================
## $Author$
## $Date$
## $Revision$
## $URL$
##====================================================

import ConfigParser
import time
from math import cos,sin,log,exp,sqrt
from numpy import loadtxt,arange,array,dot,delete,reshape,kron,eye,ones,trace,s_,r_,c_,squeeze
from numpy.linalg import svd,qr,norm
from scipy.optimize import fmin_bfgs
from _extension import *

def normalize(x):
    centroid = x.mean(0)
    x = x - centroid
    scale = norm(x,'fro')/sqrt(x.shape[0])
    x = x/scale
    return [x,centroid,scale]

def denormalize(x,centroid,scale):
    x = x*scale + centroid
    return x


def L2_distance(model, scene, scale):
    f1, g1 = gauss_transform(model, model, scale)
    f2, g2 = gauss_transform(model, scene, scale)
    f =  f1 - 2*f2
    g = 2*array(g1) - 2*array(g2)
    return f,g

def init_param(n,d,opt_affine=True):
    init_tps = [0.0]*(d*n-d*(d+1))
    init_affine = ([0.0]*d+[1.0])*d
    if opt_affine:
        init_param = init_affine+init_tps
    else:
        init_param = init_tps
    return array(init_param)

def transform_points(param, basis):
    (nL,n) = basis.shape
    d = param.shape[0]/n
    affine_param = param[0:d*(d+1)].reshape(d+1,d)
    tps_param = param[d*(d+1):d*n].reshape(n-d-1,d)
    after_tps = dot(basis,r_[affine_param,tps_param])
    return after_tps

def obj_TPS(param, basis, kernel, scene, scale, alpha, beta): #, init_affine=None):
    # (control-pts, landmarks)
    (nL,n) = basis.shape
    d = scene.shape[1]
    #if init_affine == None:
    affine_param = param[0:d*(d+1)].reshape(d+1,d)
    tps_param = param[d*(d+1):d*n].reshape(n-d-1,d)
    #else:
    #    tps_param = param[0:d*n-d*(d+1)].reshape(n-d-1,d)
    #    affine_param = init_affine.reshape(d+1,d)
    after_tps = dot(basis,r_[affine_param,tps_param])
    bending = trace(dot(tps_param.T,dot(kernel,tps_param)))
    distance, grad = L2_distance(after_tps, scene, scale)
    energy = alpha*distance + beta * bending
    return energy


def obj_TPS_gradient(param, basis, kernel, scene, scale, alpha, beta): #, init_affine=None):
    # (control-pts, landmarks)
    (nL,n) = basis.shape
    d = scene.shape[1]
    #if init_affine == None:
    affine_param = param[0:d*(d+1)].reshape(d+1,d)
    tps_param = param[d*(d+1):d*n].reshape(n-d-1,d)
    #else:
    #    tps_param = param[0:d*n-d*(d+1)].reshape(n-d-1,d)
    #    affine_param = init_affine.reshape(d+1,d)
    after_tps = dot(basis,r_[affine_param,tps_param])
    distance, grad = L2_distance(after_tps, scene, scale)
    grad = alpha*dot(basis.T, grad)
    grad[d+1:n] += 2*beta*dot(kernel,tps_param)
    #if init_affine == None:
    grad = grad.reshape(1,d*n)
    #else:
    #    grad = delete(grad,s_[0:d+1],0)
    #    grad = grad.reshape(1,d*(n-d-1))
    return squeeze(grad)

#kernel_func = [lambda r,_lambda=0: 0 if r==0 else r*r*log(r), lambda r,_lambda=0: -r]
def kernel_func_2d(r, _lambda=0):
    #_lambda reserved for regularization
    if r == 0:
        return 0
    else:
        return r*r*log(r)

def kernel_func_3d(r, _lambda=0):
    #_lambda reserved for regularization
    return -r

kernel_func = (kernel_func_2d, kernel_func_3d)

def compute_K(ctrl_pts, landmarks = None, _lambda = 0):
    """
    compute the kernel matrix for thin-plate splines
    reference:
      Landmark-based Image Analysis, Karl Rohr, p195
    """
    [n,d] = ctrl_pts.shape
    K = [kernel_func[d-2](norm(ctrl_pts[i]-ctrl_pts[j]), _lambda) for i in arange(n) for j in arange(n)]
    K = array(K).reshape(n,n)
    if not landmarks == None:
        [m,d] = landmarks.shape  # assert (d,d) equal
        U = [kernel_func[d-2](norm(landmarks[i]-ctrl_pts[j]), _lambda) for i in arange(m) for j in arange(n)]
        U = array(U).reshape(m,n)
    else:
        U = None
    return K,U

def prepare_basis(landmarks,ctrl_pts):
    [m,d] = landmarks.shape
    [n,d] = ctrl_pts.shape
    [K,U] = compute_K(ctrl_pts,landmarks)
    Pm = c_[ones((m,1)),landmarks]
    Pn = c_[ones((n,1)),ctrl_pts]
    u,s,vh = svd(Pn)
    PP = u[:,d+1:]
    TPS_basis = c_[Pm,dot(U,PP)]
    TPS_kernel = dot(PP.T,dot(K,PP))
    return TPS_basis,TPS_kernel

def run_multi_level(model,scene,ctrl_pts,level,scales,alphas,betas,iters):
    [n,d] = ctrl_pts.shape
    x0 = init_param(n,d)
    [basis, kernel] = prepare_basis(model, ctrl_pts)
    for i in range(level):
        x = fmin_bfgs(obj_TPS, x0, obj_TPS_gradient, args=(basis,kernel,scene,scales[i],alphas[i],betas[i]),maxiter=iters[i])
        x0 = x
    after_tps = transform_points(x,basis)
    return after_tps


def run_ini(f_config):
    c = ConfigParser.ConfigParser()
    c.read(f_config)
    model_file = c.get('Files','model')
    scene_file = c.get('Files','scene')
    model = loadtxt(model_file)
    scene = loadtxt(scene_file)
    try:
        ctrl_pts_file = c.get('Files','ctrl_pts')
        ctrl_pts = loadtxt(ctrl_pts_file)
    except:
        ctrl_pts = model
    level = int(c.get('Options','level'))
    option_str = c.get('Options','scale')
    scales = [float(s) for s in option_str.split(' ')]
    option_str = c.get('Options','alpha')
    alphas = [float(s) for s in option_str.split(' ')]
    option_str = c.get('Options','beta')
    betas = [float(s) for s in option_str.split(' ')]

    option_str = c.get('Optimization','max_function_evals')
    iters = [int(s) for s in option_str.split(' ')]

    normalize_flag = int(c.get('Options','normalize'))
    #print normalize_flag
    if normalize_flag==1:
        [model, c_m, s_m] = normalize(model)
        [scene, c_s, s_s] = normalize(scene)
        [ctrl_pts, c_c, s_c] = normalize(ctrl_pts)
    t1 = time.time()
    after_tps = run_multi_level(model,scene,ctrl_pts,level,scales,alphas,betas,iters)
    if normalize_flag==1:
        model = denormalize(model,c_m,s_m)
        scene = denormalize(scene,c_s,s_s)
        after_tps = denormalize(after_tps,c_s,s_s)
    t2 = time.time()
    print "Elasped time is %s seconds"%(t2-t1)
    return model,scene,after_tps
    #displayABC(model,scene,after_tps)


