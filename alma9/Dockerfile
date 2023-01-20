# podman build -t casa:6.5-znver3 --build-arg arch=znver3 .
FROM casa-env-alma9:0.1

ARG arch=native
ARG version=6.5.3.21
# Fork of CASA is built
# Change to https://open-bitbucket.nrao.edu/scm/casa/casa6.git for NRAO's repo
ARG CASA_URL=https://github.com/dic-case-studies/casa6.git

WORKDIR /home/casa

RUN git clone $CASA_URL

COPY 0001-Add-U_GLIBCXX_ASSERTIONS-for-casacore-issue.patch /home/casa/casa6/0001-Add-U_GLIBCXX_ASSERTIONS-for-casacore-issue.patch

RUN cd casa6 && \
    git checkout $version && \
    git apply 0001-Add-U_GLIBCXX_ASSERTIONS-for-casacore-issue.patch && \
    git submodule update --init --recursive && \
    cd casatools/casacore && \
    git checkout feature/simd-min-3.5.0

RUN pwd

COPY grpc-fix.patch /home/casa/casa6/casatools/grpc-source/grpc-fix.patch

RUN cd casa6/casatools && \
    autoconf && \
    ./configure PYTHON=/usr/bin/python3

RUN cd casa6/casatools/grpc-source && git apply grpc-fix.patch

RUN cd casa6/casatools/ && \
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
