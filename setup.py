"""
A setuptools based setup module.
Based on the example at:
https://packaging.python.org/en/latest/distributing.html
https://github.com/pypa/sampleproject
"""

# Always prefer setuptools over distutils
from setuptools import setup, find_packages, setuptools
# To use a consistent encoding
from codecs import open
from os import path
import aims

here = path.abspath(path.dirname(__file__))

# Get the long description from the README file
with open(path.join(here, 'README.mkdn'), encoding='utf-8') as f:
    long_description = f.read()

setup(
    name=aims.__name__,
    version=aims.__version__,

    description=aims.__description__,
    long_description=long_description,

    # The project's main homepage.
    url='https://github.com/denzuk/aims/',

    # Author details
    author=aims.__author__,
    author_email=aims.__author_email__,
    maintainer=aims.__maintainer__,,
    maintainer_email=aims.__author_email__,
    # Choose your license
    license=aims.__license__,

    # See https://pypi.python.org/pypi?%3Aaction=list_classifiers
    classifiers=[
        # How mature is this project? Common values are
        #   3 - Alpha
        #   4 - Beta
        #   5 - Production/Stable
        'Development Status :: 3 - Alpha',

        # Indicate who your project is intended for
        'Intended Audience :: Developers',
        'Topic :: System :: Hardware',

        # Pick your license as you wish (should match "license" above)
        'License :: OSI Approved :: BSD License',

        # Specify the Python versions you support here. In particular, ensure
        # that you indicate whether you support Python 2, Python 3 or both.
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3'
    ],

    # What does your project relate to?
    keywords='',

    # You can just specify the packages manually here if your project is
    # simple. Or you can use find_packages().
    packages=find_packages(exclude=['contrib', 'docs', 'tests', 'examples',
                                    'experiments', 'web_bluetooth']),
    # packages=['bluezero'],

    # Alternatively, if you want to distribute just a my_module.py, uncomment
    # this:
    #   py_modules=["my_module"],

    # List run-time dependencies here.  These will be installed by pip when
    # your project is installed. For an analysis of "install_requires" vs pip's
    # requirements files see:
    # https://packaging.python.org/en/latest/requirements.html
    install_requires=['eve'],

    # To provide executable scripts, use entry points in preference to the
    # "scripts" keyword. Entry points provide cross-platform support and allow
    # pip to create the appropriate form of executable for the target platform.
    # entry_points={
    #     'console_scripts': [
    #         'sample=sample:main',
    #     ],
    # },
)
