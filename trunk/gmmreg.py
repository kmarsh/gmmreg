import ConfigParser
import sys
import time
import subprocess

from pylab import *
import matplotlib.axes3d as ax3d

from math import cos,sin,log,exp,sqrt
from numpy import arange,array,dot,delete,reshape,kron,eye,ones,trace,s_,r_,c_,squeeze
from numpy.linalg import svd,qr,norm
from scipy.optimize import fmin_bfgs

import pycvgmi


def run(f_config, display = True):

    if sys.platform=='win32': # or os.name == 'nt'
        cmd = 'gmmreg_tps %s'%f_config
    else:
        cmd = './linux-x86_64/gmmreg_tps %s'%f_config
        
    t1 = time.time()
    subprocess.call(cmd,shell=True)
    t2 = time.time()
    print "Elasped time is %s seconds"%(t2-t1)
    
 
    if display:
        display_pts(f_config)


def display_pts(f_config):        
    c = ConfigParser.ConfigParser()
    c.read(f_config)
    mf = c.get('Files','model')
    sf = c.get('Files','scene')
    tf = c.get('Files','transformed_model')

    m = load(mf)
    s = load(sf)
    t = load(tf)
    displayABC(m,s,t)

        

def L2_distance(model, scene, scale):
    f1, g1 = pycvgmi.gauss_transform(model, model, scale)
    f2, g2 = pycvgmi.gauss_transform(model, scene, scale)
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

kernel_func = [lambda r,_lambda=0: 0 if r==0 else r*r*log(r), lambda r,_lambda=0: -r]
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

def display2Dpointsets(A, B):
    """ display a pair of 2D point sets"""
    plot(A[:,0],A[:,1],'yo',markersize=8,mew=1)    
    plot(B[:,0],B[:,1],'b+',markersize=8,mew=1)
    #pylab.setp(pylab.gca(), 'xlim', [-0.15,0.6])
    labels = getp(gca(), 'xticklabels')
    setp(labels, color='k', fontweight='bold')
    labels = getp(gca(), 'yticklabels')
    setp(labels, color='k', fontweight='bold')


def display3Dpointsets(A,B,ax):
    ax.plot3D(A[:,0],A[:,1],A[:,2],'yo',markersize=10,mew=1)    
    ax.plot3D(B[:,0],B[:,1],B[:,2],'b+',markersize=10,mew=1)
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')

def displayABC(A,B,C):
    fig = figure() 
    dim = A.shape[1]    
    if dim==2:
        subplot(1,2,1)
        display2Dpointsets(A, B)
        subplot(1,2,2)
        display2Dpointsets(C, B)
    if dim==3:
        plot1 = subplot(1,2,1)
        ax=ax3d.Axes3D(fig, rect = plot1.get_position())
        display3Dpointsets(A,B,ax)
        plot2 = subplot(1,2,2)
        ax=ax3d.Axes3D(fig, rect = plot2.get_position())
        display3Dpointsets(C,B,ax)
    show()
        



#(x,f,d) = fmin_l_bfgs_b(func, x0, fprime=None, args=(),
#                   approx_grad=0,
#                   bounds=None, m=10, factr=1e7, pgtol=1e-5,
#                   epsilon=1e-8,
#                   iprint=-1, maxfun=15000)
def rosenbrock_func(x):
    #x_min = numpy.array(1,1)
    f = (10*(x[1] - x[0]**2))**2 + (1-x[0])**2
    g0 = -40*(10*(x[1] - x[0]**2))*x[0] - 2*(1-x[0])
    g1 = 2*10*(10*(x[1] - x[0]**2))
    g = array((g0,g1))
    return f,g


def transform_by_rigid2d(pts, param):
    (x,y,theta) = param
    r = array([[cos(theta),-sin(theta)],[sin(theta), cos(theta)]])
    return dot(pts,r.T)+(x,y)


def compute_L2_distance(param, model, scene, scale):
    transformed_model = transform_by_rigid2d(model,param)
    f,g = pycvgmi.gauss_transform(transformed_model,scene,scale)
    #return -f, -numpy.array(g)
    return -f 

def run_demo(model,scene,ctrl_pts,scale):
    [n,d] = ctrl_pts.shape
    x0 = init_param(n,d)
    alpha = 10
    beta = 0
    [basis, kernel] = prepare_basis(model, ctrl_pts)
    x1 = fmin_bfgs(obj_TPS, x0, obj_TPS_gradient, args=(basis,kernel,scene,scale,alpha,beta),maxiter=100)
    after_tps = transform_points(x1,basis)
    return after_tps
    
    
def fish_demo():
    model = load('d:/gmmreg/fish_data/fish_X.txt')    
    scene = load('d:/gmmreg/fish_data/fish_Y.txt')    
    ctrl_pts = load('d:/gmmreg/fish_data/fish_ctrl_pts.txt')
    scale = 0.4    
    t1 = time.time()
    after_tps = run_demo(model,scene,ctrl_pts,scale)
    t2 = time.time()
    print "Elasped time is %s seconds"%(t2-t1)
    displayABC(model,scene,after_tps)
    
def face_demo():
    model = load('d:/gmmreg/face_data/face_X.txt')    
    scene = load('d:/gmmreg/face_data/face_Y.txt')    
    ctrl_pts = load('d:/gmmreg/face_data/face_ctrl_pts.txt')
    scale = 0.4    
    t1 = time.time()
    after_tps = run_demo(model,scene,ctrl_pts,scale)
    t2 = time.time()
    print "Elasped time is %s seconds"%(t2-t1)
    displayABC(model,scene,after_tps)

def run_ini(f_config):
    c = ConfigParser.ConfigParser()
    c.read(f_config)
    model_file = c.get('Files','model')
    scene_file = c.get('Files','scene')
    model = load(model_file)
    scene = load(scene_file)
    try:
        ctrl_pts_file = c.get('Files','ctrl_pts')
        ctrl_pts = load(ctrl_pts_file)
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
    displayABC(model,scene,after_tps)

def run_multi_level(model,scene,ctrl_pts,level,scales,alphas,betas,iters):
    [n,d] = ctrl_pts.shape
    x0 = init_param(n,d)
    [basis, kernel] = prepare_basis(model, ctrl_pts)
    for i in range(level):
        x = fmin_bfgs(obj_TPS, x0, obj_TPS_gradient, args=(basis,kernel,scene,scales[i],alphas[i],betas[i]),maxiter=iters[i])
        x0 = x
    after_tps = transform_points(x,basis)
    return after_tps
    #displayABC(model,scene,after_tps)


def normalize(x):
    centroid = x.mean(0)
    x = x - centroid
    scale = norm(x,'fro')/sqrt(x.shape[0])
    x = x/scale
    return [x,centroid,scale]
    
def denormalize(x,centroid,scale):
    x = x*scale + centroid
    return x
        

if __name__=="__main__":
    run('./fish_full.ini')
