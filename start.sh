#!/bin/bash
exec jupyter notebook --ip='0.0.0.0' --port=8888 --no-browser --NotebookApp.token='' # &
#exec jupyter lab --ip='0.0.0.0' --port=8889 --no-browser --LabApp.token=''
