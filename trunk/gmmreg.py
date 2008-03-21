from pylab import *

import pygmmreg
import ConfigParser

def run(ini):
     
    #ini = './fish_full.ini'
    pygmmreg.gmmreg_tps_ini(ini)

    c = ConfigParser.ConfigParser()
    c.read(ini)
    mf = c.get('Files','modelfile')
    sf = c.get('Files','scenefile')
    tf = c.get('Files','afterregptsfile')

    m = load(mf)
    s = load(sf)
    t = load(tf)

    subplot(1,2,1)
    plot(s[:,0],s[:,1],'yo',markersize=16,mew=1)    
    plot(m[:,0],m[:,1],'b+',markersize=16,mew=1)


    subplot(1,2,2)
    plot(s[:,0],s[:,1],'yo', markersize=16,mew=1)
    plot(t[:,0],t[:,1],'b+', markersize=16,mew=1)

    show()
    

if __name__=="__main__":
    run('./fish_full.ini')