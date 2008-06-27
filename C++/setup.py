from distutils.core import setup, Extension

pygmmreg = Extension('pygmmreg',
                     define_macros = [('MAJOR_VERSION', '1'),
                                      ('MINOR_VERSION', '0')],
                     include_dirs = ['/usr/include'],
                     libraries = ['gmmreg_L2_tps','gmmreg_cpd'],
                     library_dirs = ['/usr/lib64','./build'],
                     sources = ['pygmmreg.cpp'])

setup (name = 'pygmmreg',
              version = '1.0',
              description = 'This is a Python extension of gmmreg.',
              author = 'Bing Jian',
              author_email = 'bing.jian@gmail.com',
              url = 'http://www.python.org/doc/current/ext/building.html',
              long_description = '''
              This is a Python extension of gmmreg.
              ''',
              ext_modules = [pygmmreg])
