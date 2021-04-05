#!/bin/bash

# Load necessary modules
module load python3 pylauncher netcdf/4.3.3.1 hdf5/1.8.16
module list
pwd
date

# Set proper conda env
source ~/miniconda3/etc/profile.d/conda.sh
conda activate aps
OLDPATH=$(echo $PYTHONPATH)
export PYTHONPATH=$CONDA_PREFIX/bin

# Copy base adcirc inputs and executables to job directory
cp -r ${ADCIRC_INPUTS} base_inputs
cp -r ${ADCIRC_EXECS} execs

# Copy generator script to general path so init.py can read
cp ${GENERATOR_SCRIPT} generator.py

# Call param_scan.py setup_job ->
#  - Creates input files using input generator func
#  - Writes parallelines.csv file for pylauncher to use
#  - Creates launcher script that starts pylauncher
python init.py "${NP}"

# Launch pylauncher
# Note we launch this with python3 to point to pyhtonpath that has
# pylauncher module loaded. Also we restore old python path
export PYTHONPATH=$OLDPATH
python3 launch.py

exit 0
