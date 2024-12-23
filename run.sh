#!/bin/bash

#docker run -it \
#    -v $HOME/Documents/cesm_inputs:/root/cesm \
#    cesm_ftorch /bin/bash


docker run -it \
    -v $HOME/Documents/cesm_inputs:/root/cesm \
    -v $HOME/Documents/CAM:/opt/cesm/components/cam \
    -v $HOME/Documents/weights:/weights \
   cesm_ftorch /bin/bash
