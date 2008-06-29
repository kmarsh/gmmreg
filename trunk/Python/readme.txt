##=====================================================================
## $RCSfile: readme.txt,v $
## $Author: bjian $
## $Date: 2008/06/28 23:45:57 $
## $Revision: 1.3 $
##=====================================================================

This directory contains the Python code for the robust point-set
registration algorithm described in the ICCV'05 paper:

"Bing Jian and Baba C. Vemuri, 
A Robust Algorithm for Point Set Registration Using Mixture of Gaussians."


It is a part of software package which can be freely downloaded from
http://www.cise.ufl.edu/research/cvgmi/Software.php#gmmreg


Files in this "Python" directory are organized as follows:

Python/  
	gmmreg_demo.py
	    There are two different demo functions in this module. 	
	    (1)run_cppdemo() is a wrapper of the C++ implementation in C++ directory
	    (2)run_demo() is based on the Python implementation in gmmreg_core.py
            The plotting uses the matplotlib package. 

	gmmreg_core.py
	    The Python implementation of the algorithm.  			
	    The core algorithm requires SciPy, NumPy and the pycvgmi extension.

	pycvgmi/
	    The source code for the pycvgmi extension. The GaussTransform called
	    in gmmreg_core is implemented here as pycvgmi.gauss_transform().
            Use "python setup.py build" to generate the extension module.
	    	

If you have any questions, please contact bing.jian@gmail.com