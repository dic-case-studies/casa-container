# casa-container

## Building the images

**Base Alma Linux 9 image with all dependencies to build CASA:**

```podman build -t casa-env-alma9:0.1 -f alma9/Dockerfile_env .```

**Image with CASA inside**

```podman build -t casa:6.5-znver3 -f alma9/Dockerfile --build-arg arch=znver3 .```


**Image to fetch machine information**

```podman build -f Dockerfile_march -t fetch_march:0.1 .```


## Running Images

**To rum image with CASA inside**

```
# For SELinux based distro RHEL, Centos, Alma, Rocky
podman rum --rm -it -v $PWD:/home/casa:z casa:6.5-znver3

# For other disto
podman rum --rm -it -v $PWD:/home/casa casa:6.5-znver3
```


**To fetch machine information**

```podman run -rm fetch_march:0.1```



