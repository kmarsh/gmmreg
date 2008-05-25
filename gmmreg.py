import ConfigParser
import time
import subprocess

from pylab import *
import matplotlib.axes3d as ax3d


def run(f_config):
     
    cmd = './gmmreg_tps %s'%f_config;
    t1 = time.clock()
    subprocess.call(cmd)
    t2 = time.clock()
    print "Elasped time is %s seconds"%(t2-t1)
    c = ConfigParser.ConfigParser()
    c.read(f_config)
    mf = c.get('Files','model')
    sf = c.get('Files','scene')
    tf = c.get('Files','transformed_model')

    m = load(mf)
    s = load(sf)
    t = load(tf)
    dim = m.shape[1]

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
        fig = figure()
        ax=ax3d.Axes3D(fig)
        ax.plot3D(s[:,0],s[:,1],s[:,2],'yo',markersize=10,mew=1)    
        ax.plot3D(m[:,0],m[:,1],m[:,2],'b+',markersize=10,mew=1)
        ax.set_xlabel('X')
        ax.set_ylabel('Y')
        ax.set_zlabel('Z')

        fig = figure()
        ax=ax3d.Axes3D(fig)
        ax.plot3D(s[:,0],s[:,1],s[:,2],'yo',markersize=10,mew=1)    
        ax.plot3D(t[:,0],t[:,1],t[:,2],'b+',markersize=10,mew=1)
        ax.set_xlabel('X')
        ax.set_ylabel('Y')
        ax.set_zlabel('Z')

    show()
        


if __name__=="__main__":
    run('./fish_full.ini')