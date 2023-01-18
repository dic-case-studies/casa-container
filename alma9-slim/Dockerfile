FROM almalinux:9

ARG arch=native
ARG version=6.5.3.21

WORKDIR /home/casa

COPY 0001-Update-casatools-build-to-compile-with-march.patch /home/casa/0001-Update-casatools-build-to-compile-with-march.patch

COPY grpc-fix.patch /home/casa/grpc-fix.patch

RUN dnf install -y 'dnf-command(config-manager)' && \
    dnf config-manager --set-enabled crb && \
    dnf install -y epel-release && \
    yum update -y  && \
    \
    # Casacore deps
    yum -y install cmake cmake-gui wget git gcc-gfortran gcc-c++ flex bison \
        blas blas-devel lapack lapack-devel cfitsio cfitsio-devel \
        ncurses ncurses-devel readline readline-devel \
        fftw fftw-devel hdf5 hdf5-devel libgomp  && \
    \
    # RHEL 9's EPEL does not have wcslib
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    yum install -y wcslib wcslib-devel  && \
    \
    # Python deps
    yum -y install python3-devel boost boost-devel \
        boost-python3 python3-numpy-f2py python3-numpy python3-pip \
        libjpeg-turbo libjpeg-turbo-devel libxslt libxslt-devel  && \
    \
    # casa does not work with swig4, installing swig3
    pip3 install matplotlib packaging certifi scipy swig==3.0.12  && \
    \
    # Other deps
    yum -y install xerces-c xerces-c-devel libgomp openmpi openmpi-devel environment-modules libxml2 libxml2-devel \
    java-11-openjdk rsync libtool libsqlite3x-devel \
    ccache xerces-c gsl gsl-devel && \
                              \
    yum install -y https://casa.nrao.edu/download/repo/el7/x86_64/rpfits-2.23-02.el7.x86_64.rpm && \
                                  \
    yum install -y https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/s/shtool-2.0.8-11.el7.noarch.rpm  && \
    \
    # Module files
    echo "source /usr/share/Modules/init/bash" >> ~/.bashrc && \
    echo "module load mpi/openmpi-x86_64" >> ~/.bashrc && \
    source ~/.bashrc  && \
    git clone https://open-bitbucket.nrao.edu/scm/casa/casa6.git && \
    cp /home/casa/0001-Update-casatools-build-to-compile-with-march.patch /home/casa/casa6/0001-Update-casatools-build-to-compile-with-march.patch && \
    \
    # Configure CASA and run
    cd /home/casa/casa6 && \
    git checkout $version && \
    git apply 0001-Update-casatools-build-to-compile-with-march.patch && \
    git submodule update --init --recursive && \
    cd casatools/casacore && \
    git checkout feature/simd-min-3.5.0 && \
    \
    # GRPC Fix
    cp /home/casa/grpc-fix.patch /home/casa/casa6/casatools/grpc-source/grpc-fix.patch && \
    cd /home/casa/casa6/casatools/grpc-source && git apply grpc-fix.patch && \
    \
    # Build casatools
    cd /home/casa/casa6/casatools && \
    autoconf && \
    ./configure PYTHON=/usr/bin/python3 && \
    \
    cd /home/casa/casa6/casatools/ && \
    ./setup.py build --march=$arch && \
    ./setup.py install --march=$arch && \
    python3 -m casatools --update-user-data && \
    \
    cd /home/casa/casa6/casatasks && \
    ./setup.py build && \
    ./setup.py install && \
    \
    cd /home/casa/ && \
    git clone https://open-bitbucket.nrao.edu/scm/casa/casashell.git && \
    cd casashell && \
    ./setup.py build && \
    ./setup.py install && \
    \
    rm -rf /home/casa/casa6 /home/casa/casashell /root/.ccache && \
# OpenMPI devel removal has been removed
    yum -y remove blas-devel lapack-devel cfitsio-devel \
        ncurses-devel  readline-devel \
        fftw-devel hdf5-devel wcslib-devel boost-devel libjpeg-turbo-devel libxslt-devel \
        xerces-c-devel libxml2-devel libsqlite3x-devel gsl-devel

ENTRYPOINT ["python3", "-m", "casashell"]
