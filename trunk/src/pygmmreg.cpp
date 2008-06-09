#include <Python.h>
#include "gmmreg_L2_tps_api.h"
#include "gmmreg_cpd_api.h"

static PyObject *
py_gmmreg_L2_tps(PyObject *self, PyObject *args)
{
	char *f_config;
	/* send Python arrays to C */
    if (!PyArg_ParseTuple(args, "s",  &f_config))
	{
        return NULL;
	}	
	
	/* call function */
	gmmreg_L2_tps_api(f_config);	
	
	/* send the result back to Python */
	//Py_DECREF(f_config);
	return Py_BuildValue("s", f_config);
}

static PyObject *
py_gmmreg_cpd(PyObject *self, PyObject *args)
{
	char *f_config;
	/* send Python arrays to C */
    if (!PyArg_ParseTuple(args, "s",  &f_config))
	{
        return NULL;
	}	
	
	/* call function */
	gmmreg_cpd_api(f_config);	
	
	/* send the result back to Python */
	//Py_DECREF(f_config);
	return Py_BuildValue("s", f_config);
}

static PyMethodDef GMMRegMethods[] = {
    {"L2_tps",  py_gmmreg_L2_tps, METH_VARARGS,
     "GMMReg using L2 distance and TPS."},
	{"cpd",  py_gmmreg_cpd, METH_VARARGS,
	 "GMMReg using Coherent Point Drift."},
	 {NULL, NULL, 0, NULL}        /* Sentinel */
};

PyMODINIT_FUNC
initpygmmreg(void)
{
    (void) Py_InitModule("pygmmreg", GMMRegMethods);
	//import_array();
}
