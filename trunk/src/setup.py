from distutils.core import setup, Extension

module1 = Extension('pygmmreg',
                     define_macros = [('MAJOR_VERSION', '1'),
                                      ('MINOR_VERSION', '0')],
                     include_dirs = ['/usr/include'],
                     libraries = ['gmmreg_L2_tps','gmmreg_cpd'],
                     library_dirs = ['/usr/lib64','./build'],
                     sources = ['pygmmreg.cpp'])

setup (name = 'PackageName',
              version = '1.0',
              description = 'This is a demo package',
              author = 'Martin v. Loewis',
              author_email = 'martin@v.loewis.de',
              url = 'http://www.python.org/doc/current/ext/building.html',
              long_description = '''
              This is really just a demo package.
              ''',
              ext_modules = [module1])
