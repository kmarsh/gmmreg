#!/usr/bin/env python
#coding=utf-8

##=============================================================
## Module:    $RCSfile: fundamental_matrix.py,v $
## Language:  Python
## Author:    $Author: bjian $
## Date:      $Date: 2008/03/22 05:34:36 $
## Version:   $Revision: 1.1 $
##=============================================================

import ConfigParser
import sys
import time
import subprocess

from pylab import *
import matplotlib.axes3d as ax3d
import gmmreg_core


def run_demo(f_config):
    model,scene,after_tps = gmmreg_core.run_ini(f_config)
    displayABC(model,scene,after_tps)
    

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


def run_cppdemo(f_config, display = True):
    if sys.platform=='win32': # or os.name == 'nt'
        gmmreg_prog = 'gmmreg_tps'
    else:
        gmmreg_prog = './linux-x86_64/gmmreg_tps'
    cmd = '%s %s'%(gmmreg_prog, f_config)
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



if __name__=="__main__":
    run_cppdemo('./face.ini')
