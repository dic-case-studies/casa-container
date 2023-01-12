# podman build -t casa:6.5-znver3 --build-arg arch=znver3 .
FROM casa-env:0.1

ARG arch=native
ARG version=6.5.3.21

WORKDIR /home/casa

RUN git clone https://open-bitbucket.nrao.edu/scm/casa/casa6.git

RUN cd casa6 && \
    git checkout $version && \
    wget https://gist.githubusercontent.com/Mark1626/d30561267b7743abcfdee4fb27144d99/raw/ac46670ce9ae1aa0fb32ba75e216473a99dfc4e3/0001-Update-casatools-build-to-compile-with-march.patch && \
    git apply 0001-Update-casatools-build-to-compile-with-march.patch && \
    git submodule update --init --recursive && \
    cd casatools/casacore && \
    git checkout feature/simd-min-3.5.0

RUN cd casa6/casatools && \
    autoconf && \
    ./configure PYTHON=/usr/bin/python3 && \
    ./setup.py build --march=$arch && \
    ./setup.py install --march=$arch && \
    python3 -m casatools --update-user-data

RUN cd casa6/casatasks && \
    ./setup.py build && \
    ./setup.py install

RUN git clone https://open-bitbucket.nrao.edu/scm/casa/casashell.git && \
    cd casashell && \
    ./setup.py build && \
    ./setup.py install

ENTRYPOINT ["python3", "-m", "casashell"]
