FROM cesm:latest

# Install dependencies
RUN conda install -y pyyaml typing_extensions numpy
#RUN conda install -y pytorch torchvision torchaudio pytorch-cuda=12.4 -c pytorch -c nvidia

# Install build tools
RUN apt-get update && apt-get install -y \
    ccache \
    ninja-build \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Set up ccache
ENV PATH=/usr/lib/ccache:$PATH \
    CCACHE_DIR=/ccache \
    CCACHE_MAXSIZE=10G

# Install LibTorch
RUN wget https://download.pytorch.org/libtorch/cu124/libtorch-cxx11-abi-shared-with-deps-2.5.1%2Bcu124.zip -O libtorch.zip && \
    unzip libtorch.zip -d /usr/local && \
    rm libtorch.zip

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
    -DCMAKE_PREFIX_PATH=/usr/local/libtorch \
    -DCMAKE_INSTALL_PREFIX=/usr/local/ftorch

RUN make && make install

# Add To LD_PATH
ENV CUDA_HOME=/usr/local/cuda
ENV LD_LIBRARY_PATH=/usr/local/ftorch/lib:$LD_LIBRARY_PATH 
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64"

ENV LD_LIBRARY_PATH=/usr/local/libtorch/lib:$LD_LIBRARY_PATH
ENV Torch_DIR=/usr/local/libtorch/share/cmake/Torch

# Copy Makefile
COPY files/Makefile /opt/cesm/cime/scripts/Tools/Makefile 

ENV PATH=/opt/cesm/cime/scripts:$PATH

WORKDIR /root
