# Docker shell environment

## Setup the local environment to allow X11 forwarding to the host system

```zsh
export IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
xhost + $IP
open -a XQuartz
```

## Build and Run this container

```zsh
docker build -t zsh:0.4 .
docker run  -it --rm -e DISPLAY=$IP:0 -v /tmp/.X11-unix:/tmp/.X11-unix --volume /Users/robert/Documents:/home/robert/Documents zsh:0.4 zsh
```
