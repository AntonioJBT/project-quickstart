#!/usr/bin/env bash

echo "
This script is intended as an example only.
If you get errors simply copy-paste commands and adapt to
the system you are working on.
"

# Set bash script options:
# https://kvz.io/blog/2013/11/21/bash-best-practices/
# Exit when a command fails:
set -o errexit
# Catch  piped commands which fail. The exit status of
# the last command that threw a non-zero exit code is returned:
set -o pipefail
# Exit when trying to use an undeclared variable:
set -o nounset

# You need to install conda first, then run:

# Specify conda channels to avoid clashes with R (this will add channels to your .condarc):
conda config --add channels conda-forge
conda config --add channels bioconda
conda config --add channels r

# Create conda environment:
conda create -yn pq_test
conda activate pq_test

# You may need to install compilers:
#conda install gxx_linux-64 gcc_linux-64 gfortran_linux-64

# Install R:
conda install -y r=3.4

# Install python:
conda install -y python=3.5
# issues with cairo with python 3.7

# Install project_quickstart and pq_example requirements:
bash -c 'pip install project_quickstart ; \
         conda install -y r-docopt r-data.table r-ggplot2 r-stringr ; \
         conda install -y docopt pandas matplotlib scipy svgutils cairosvg'

# Get R packages not available with conda (in the channels specified, might be
# elsewhere):
R --vanilla -e 'source("http://bioconductor.org/biocLite.R") ; install.packages("stargazer", repos = "http://cran.us.r-project.org") ; library("stargazer")'
R --vanilla -e 'source("http://bioconductor.org/biocLite.R") ; install.packages("svglite", repos = "http://cran.us.r-project.org") ; library("svglite")'
# svglite fails due to gdtools failing for R 3.5

# Install latex and requirements for report building:
bash -c 'conda install -y sphinxcontrib-bibtex' # for both pdf and html reports
bash -c 'conda install -y texlive-core latexmk perl-local-lib perl==5.20.3.1' # for pdf reports
# latexmk and perl may conflict though (unsatisfiable error...)
# latexmk is needed for make latexpdf but needs perl 5.20.3.1
# perl-local-lib needs perl > 5.26.2
# perl and perl local::lib are needed for latex and sphinx report building, perl without local::lib gives compilation errors and missing modules
# This only affects latex and pdf building though, html reports are fine


# Install CGAT tools
# cgat-core:
#bash -c 'wget https://raw.githubusercontent.com/cgat-developers/cgat-core/master/conda_requires.txt ; \
#         while read requirement; do conda install --yes $requirement; done < conda_requires.txt ; \
#         conda install -y sqlalchemy ; \
#         pip install git+git://github.com/cgat-developers/cgat-core.git '

# Check things are installed with eg:
#while read requirement; do conda list | grep $requirement; done < conda_requires.txt

# Finish and deactivate conda environment:
conda deactivate
echo "All done, packages downloaded and installed. Activate your environment
using 'conda activate pq_test'"
