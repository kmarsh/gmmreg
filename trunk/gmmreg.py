import ConfigParser
import sys
import time
import subprocess

from pylab import *
import matplotlib.axes3d as ax3d


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
    dim = m.shape[1]

    fig = figure() 
    if dim==2:
        subplot(1,2,1)
        plot(s[:,0],s[:,1],'yo', markersize=10,mew=1)
        plot(m[:,0],m[:,1],'b+', markersize=10,mew=1)

        subplot(1,2,2)
        plot(s[:,0],s[:,1],'yo', markersize=10,mew=1)
        plot(t[:,0],t[:,1],'b+', markersize=10,mew=1)
        width = t[:,0].max() - t[:,0].min()
        x_min = t[:,0].min() - width/10
        x_max = t[:,0].max() + width/10
        setp(gca(), 'xlim', [x_min,x_max])

    if dim==3:
        plot1 = subplot(1,2,1)
        ax=ax3d.Axes3D(fig, rect = plot1.get_position())
        ax.plot3D(s[:,0],s[:,1],s[:,2],'yo',markersize=10,mew=1)    
        ax.plot3D(m[:,0],m[:,1],m[:,2],'b+',markersize=10,mew=1)
        ax.set_xlabel('X')
        ax.set_ylabel('Y')
        ax.set_zlabel('Z')

        plot2 = subplot(1,2,2)
        ax=ax3d.Axes3D(fig, rect = plot2.get_position())
        ax.plot3D(s[:,0],s[:,1],s[:,2],'yo',markersize=10,mew=1)    
        ax.plot3D(t[:,0],t[:,1],t[:,2],'b+',markersize=10,mew=1)
        ax.set_xlabel('X')
        ax.set_ylabel('Y')
        ax.set_zlabel('Z')

    show()
        


if __name__=="__main__":
    run('./fish_full.ini')
