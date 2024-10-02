# CAM/CESM on with GPU support 
Build container with support for CESM to call out to libtorch models. 
Note: GPU support is still being worked on, issues with compiler versions. 

<div style="text-align: center;">
  <img src="images/climate_computer.jpg" style="width:50%;">
  <p><em>AI for Climate Models!</em></p>
</div>

## Build Image
1. Build [CESM_Docker](https://github.com/scotty110/CESM_Docker) first. This will setup CESM and all dependencies. 
2. Then in `cesm_ftorch` run `./build` to build the cam_cuda container

## CAM
Clone CAM [Link](https://github.com/scotty110/CAM) using `git clone https://github.com/scotty110/CAM.git`. 

## Modifying Makefile to find FTorch
Modify line 565 in `scripts/Tools/Makefile` (`/opt/cesm/cime/scripts/Tools/Makefile`)
Adding: 

```
# Set FTorch info if it is being used
ifeq ($(strip $(USE_FTORCH)), True)
  FTORCH_LOC := /usr/local/ftorch
  INCLDIR += -I$(FTORCH_LOC)/include/ftorch
  SLIBS += -L$(FTORCH_LOC)/lib -lftorch
  LDFLAGS += -Wl,-rpath,$(FTORCH_LOC)/lib
endif
FTORCH_LOC := /opt/libtorch
INCLDIR += -I$(FTORCH_LOC)/include/ftorch
SLIBS += -L$(FTORCH_LOC)/lib -lftorch
LDFLAGS += -Wl,-rpath,$(FTORCH_LOC)/lib
```
Use the included `files/Makefile` as a reference.

