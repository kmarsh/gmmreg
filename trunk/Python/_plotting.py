#!/usr/bin/env python
#coding=utf-8

##====================================================
## $Author$
## $Date$
## $Revision$
## $URL$
##====================================================


from pylab import *

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
        if True: #try:
            import matplotlib.axes3d as ax3d
            plot1 = subplot(1,2,1)
            ax = ax3d.Axes3D(fig, rect = plot1.get_position())
            display3Dpointsets(A,B,ax)
            plot2 = subplot(1,2,2)
            ax = ax3d.Axes3D(fig, rect = plot2.get_position())
            display3Dpointsets(C,B,ax)
        else: #except:
            print "Since version 0.98.1, the axes3d is no longer supported in matplotlib."
            print "http://mail.python.org/pipermail/python-announce-list/2008-August/006789.html"
            return
    show()




