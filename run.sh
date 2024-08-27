#!/bin/bash

#docker run -it -v $HOME/Documents/cesm_inputs:/root/cesm cam_cuda /bin/bash
#    -v $HOME/Documents/CAM:/opt/cesm/components/cam \
#   cam_cuda /bin/bash
docker run -it \
    --runtime=nvidia \
    -v $HOME/Documents/CAM:/opt/cesm/components/cam \
    -v $HOME/Documents/cesm_inputs:/root/cesm \
    -v $HOME/Documents/cam_weights:/weights \
    cesm_ftorch /bin/bash

