# casa-container

This repo contains Dockerfiles for building CASA 6.5 from source. The possibility of machine tuned containers in explored in this repo.

Built images are available in Dockerhub

https://hub.docker.com/repository/docker/mark9696/casa

## Building the images

For building micro-architecture tuned images you need to know the argument needed to be passed to GCC's `-march` flag. A simple utility image is present for this.

**Image to fetch machine information**

This is an Alma 9 image with GCC 11. Running this image will fetch the machine information with `gcc -march=native -Q --help=target`

```
podman build -f Dockerfile_march -t fetch_march:0.1 .
podman run --rm fetch_march:0.1
```

### CASA

This builds CASA 6.5 from source tuned for the passed microarchitecture, the final image is approx 3.5GB

```
podman build -t casa:6.5-znver3 -f alma9-slim/Dockerfile --build-arg arch=znver3 .
```

### Nextflow

The nextflow pipeline is used to build multiple images for the list of architectures present in `buildImage.nf`

```
nextflow run buildImage.nf
```

### Development Images

These images are meant for development purposes; this contains devel packages, the CASA source, cache from building CASA, the purpose of this is to modify the source and reuse the cache to build changes. The final image in this method is approx 11GB

**Base Alma Linux 9 image with all dependencies to build CASA:**

```podman build -t casa-env-alma9:0.1 -f alma9/Dockerfile_env .```

**Image with CASA inside**

```podman build -t casa:6.5-znver3 -f alma9/Dockerfile --build-arg arch=znver3 .```

----------------------------------------------------------------------------------------------

## Running Images

**To run image with CASA inside**

```
# For SELinux based distro RHEL, Centos, Alma, Rocky

# To run casashell
podman run --rm -it -v $PWD:/home/casa:z casa:6.5-znver3

# To run a script file with casa
podman run --rm -it -v $PWD:/home/casa:z casa:6.5-znver3 -c <script_file>


# For other disto
podman run --rm -it -v $PWD:/home/casa casa:6.5-znver3
```

<!--
**To run CAPTURE**

```
podman run --rm -it -v $PWD:/home/casa/CAPTURE-CASA6/data:z capture:2.0.0-skylake
```
-->

