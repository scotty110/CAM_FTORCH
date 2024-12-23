FROM cesm:latest

# Install dependencies
RUN conda install -y pyyaml typing_extensions numpy

# Install build tools
RUN apt-get update && apt-get install -y \
    ccache \
    ninja-build \
    && rm -rf /var/lib/apt/lists/*

# Set up ccache
ENV PATH=/usr/lib/ccache:$PATH \
    CCACHE_DIR=/ccache \
    CCACHE_MAXSIZE=10G

# Clone and build PyTorch
WORKDIR /opt
RUN git clone -b main https://github.com/pytorch/pytorch.git && \
    cd pytorch && \
    # Initialize all submodules
    git submodule sync && \
    git submodule update --init --recursive

WORKDIR /opt/pytorch_build
RUN cmake \
    -GNinja \
    -DBUILD_SHARED_LIBS:BOOL=ON \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DUSE_CUDA=OFF \
    -DCMAKE_INSTALL_PREFIX:PATH=../libtorch \
    -DCMAKE_C_COMPILER=gcc \
    -DCMAKE_CXX_COMPILER=g++ \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    -DUSE_CUDA_STATIC_LINK=OFF \
    -DUSE_CUDNN=OFF \
    -DUSE_NCCL=OFF \
    -DUSE_OPENCV=OFF \
    -DUSE_NUMPY=OFF \
    -DUSE_DISTRIBUTED=OFF \
    -DUSE_OPENMP=OFF \
    -DUSE_MKLDNN=OFF \
    -DUSE_FMT=ON \
    -DBUILD_PYTHON=OFF \
    -DBUILD_TEST=OFF \
    -DBUILD_DOCS=OFF \
    -DINSTALL_TEST=OFF \
    -DUSE_ITT=OFF \
    -DWERROR=OFF \
    -DUSE_VALGRIND=OFF \
    -DUSE_MLCOMPUTE=OFF \
    -DPYTHON_EXECUTABLE=$(which python3) \
    -DTORCH_DISABLE_GPU_ASSERTS=ON \
    -DUSE_OBSERVERS=OFF \
    -DUSE_ROCM=OFF \
    -DUSE_ZMQ=OFF \
    -DUSE_NUMA=OFF \
    -DUSE_SYSTEM_EIGEN_INSTALL=OFF \
    -DUSE_DISTRIBUTED=OFF \
    -DATEN_NO_TEST=ON \
    ../pytorch

RUN cmake --build . --target install -- -j$(nproc) 

# Install FTorch
WORKDIR /opt
RUN git clone https://github.com/Cambridge-ICCS/FTorch.git /opt/FTorch

WORKDIR /opt/FTorch/src/build
RUN cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_Fortran_COMPILER=gfortran \
    -DCMAKE_C_COMPILER=gcc \
    -DCMAKE_CXX_COMPILER=g++ \
    -DUSE_CUDA=OFF \
    -DCMAKE_PREFIX_PATH=/opt/libtorch \
    -DCMAKE_INSTALL_PREFIX=/usr/local/ftorch

RUN make && make install

# Add To LD_PATH
ENV LD_LIBRARY_PATH=/usr/local/ftorch/lib:$LD_LIBRARY_PATH 
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/"

# Copy Makefile
COPY files/Makefile /opt/cesm/cime/scripts/Tools/Makefile 

ENV PATH=/opt/cesm/cime/scripts:$PATH

WORKDIR /root
