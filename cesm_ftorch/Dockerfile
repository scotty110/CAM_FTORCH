FROM cesm:latest

# Install Libtorch and FTorch

RUN conda install -y pyyaml typing_extensions numpy 

# Need to build LibTorch from Source (https://github.com/pytorch/pytorch/blob/main/docs/libtorch.rst#building-libtorch-using-cmake)
WORKDIR /opt 
RUN git clone -b main --recurse-submodule https://github.com/pytorch/pytorch.git

WORKDIR /opt/pytorch_build

# Set environment variables for CUDA
ENV CUDA_HOME=/usr/local/cuda
ENV CUDNN_INCLUDE_DIR=/usr/local/cuda/include
ENV CUDNN_LIB_DIR=/usr/local/cuda/lib64

# Build PyTorch with CUDA support
RUN cmake -DBUILD_SHARED_LIBS:BOOL=ON \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DPYTHON_EXECUTABLE:PATH=`which python3` \
    -DUSE_CUDA=ON \
    -DCUDA_TOOLKIT_ROOT_DIR=$CUDA_HOME \
    -DCMAKE_INSTALL_PREFIX:PATH=../libtorch \
    ../pytorch

#RUN cmake --build . --target install 
RUN cmake --build . --target install -- -j $(nproc)

# Install FTorch
WORKDIR /opt
RUN git clone https://github.com/Cambridge-ICCS/FTorch.git /opt/FTorch

WORKDIR /opt/FTorch/src/build
RUN cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_Fortran_COMPILER=gfortran \
    -DCMAKE_C_COMPILER=gcc \
    -DCMAKE_CXX_COMPILER=g++ \
    -DUSE_CUDA=ON \
    -DCUDA_BIN_PATH=/usr/local/cuda/bin \
    -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
    -DCUDA_LIB_DIR=/usr/local/cuda/lib64 \
    -DCMAKE_PREFIX_PATH=/opt/libtorch \
    -DCMAKE_INSTALL_PREFIX=/usr/local/ftorch

RUN make && make install

# Add To LD_PATH
ENV LD_LIBRARY_PATH=/usr/local/ftorch/lib:$LD_LIBRARY_PATH 
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/"

# Revert to gcc-9.5
# Install GCC-9
#RUN apt remove -y gcc && apt update && apt install -y gcc-9 g++-9
#RUN ln -s /usr/bin/gcc-9 /usr/bin/gcc
#RUN ln -s /usr/bin/g++-9 /usr/bin/g++

# Install Fortran
# Build for source maybe if becomes outdated: https://gcc.gnu.org/wiki/GFortranBinaries#FromSource
#RUN apt install -y gfortran-9 
#RUN ln -s /usr/bin/gfortran-9 /usr/bin/gfortran

WORKDIR /opt/cesm/cime/scripts