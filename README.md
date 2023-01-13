# casa-container

## Building the images

**Base Alma Linux 9 image with all dependencies to build CASA:**

`podman build -t casa-env-alma9:0.1 -f alma9/Dockerfile_env .`

**Image with CASA inside**

`podman build -t casa:6.5-znver3 -f alma9/Dockerfile --build-arg arch=znver3 .`
