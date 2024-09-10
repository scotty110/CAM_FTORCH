#!/bin/bash

docker run -it \
    -v $HOME/Documents/code/cesm_inputs:/root/cesm \
    cesm_ftorch /bin/bash

