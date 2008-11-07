#!/usr/bin/env python
#coding=utf-8

##====================================================
## $RCSfile: fundamental_matrix.py,v $
## $Author$
## $Date$
## $Revision$
## $URL$
## $ID$
##====================================================

import time
import subprocess
import ConfigParser

from numpy import loadtxt

import _core
import _plotting

def test(f_config, display = True):
    model,scene,after_tps = _core.run_ini(f_config)
    if display:
        _plotting.displayABC(model,scene,after_tps)


def run_executable(gmmreg_exe, f_config, display = True):
    """
    import sys
    if sys.platform=='win32': # or os.name == 'nt'
        gmmreg_exe = 'gmmreg_tps'
    else:
        gmmreg_exe = './linux-x86_64/gmmreg_tps'
    """
    cmd = '%s %s'%(gmmreg_exe, f_config)
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

    m = loadtxt(mf)
    s = loadtxt(sf)
    t = loadtxt(tf)
    _plotting.displayABC(m,s,t)




