from setuptools import setup
from setuptools.extension import Extension

import os, sys

class SetupOptions(dict):
    def add(self, **kwargs):
        self.update(kwargs)

opts = SetupOptions()

opts.add(
    name='cymove',
    version='1.0.2',
    author='Omer Ozarslan',
    url='https://github.com/ozars/cymove',
    description='std::move wrapper for cython',
    long_description=open('README.md').read(),
    long_description_content_type='text/markdown',
    license='MIT',
    packages=['cymove'],
    include_package_data=True,
    package_data={'': ['LICENSE', 'README.md', 'cymove/__init__.pxd']},
    zip_safe=False,
    classifiers=[
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Operating System :: MacOS',
        'Operating System :: Microsoft :: Windows',
        'Operating System :: POSIX :: Linux',
        'Programming Language :: C++',
        'Programming Language :: Cython',
    ]
)

include_tests = len(sys.argv) >= 2 and sys.argv[1] == 'test'

if include_tests:
    extensions = [
            Extension('cymove_test', ['cymove/cymove_test.pyx'],
                language='c++', extra_compile_args=['-std=c++11'])
    ]

    opts.add(
        setup_requires = ['cython'],
        test_suite = 'cymove_test',
        ext_modules = extensions,
    )

setup(**opts)
