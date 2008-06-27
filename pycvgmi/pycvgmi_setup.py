from distutils.core import setup, Extension

module_pycvgmi = Extension('pycvgmi',
                     define_macros = [('MAJOR_VERSION', '1'),
                                      ('MINOR_VERSION', '0')],
                     include_dirs = ['/usr/include','/usr/include/python2.4','/cise/research51/cvgmi_04/local/include'],
                     libraries = ['cvgmi'],
                     library_dirs = ['/usr/lib64','/cise/research51/cvgmi_04/local/lib'],
                     sources = ['pycvgmi.c'])

setup (name = 'pycvgmi',
              version = '1.0',
              description = 'This is a python extension package of some C/C++ API functions developed in CVGMI group.',
              author = 'Bing Jian',
              author_email = 'bing.jian@gmail.com',
              url = 'http://www.cise.ufl.edu/research/cvgmi/',
              long_description = '''
              This is a python extension package of some C/C++ API functions developed in CVGMI group.
              ''',
              ext_modules = [module_pycvgmi])
