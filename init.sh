#!/bin/bash
docker volume create zsh-vol
docker build -t zsh:0.4 .
docker create --name zsh --hostname docker-zsh -it --rm -e DISPLAY=$IP:0 -v /tmp/.X11-unix:/tmp/.X11-unix --volume /Users/robert/Documents:/home/robert/Documents --mount source=zsh-vol,target=/home/robert zsh:0.4 zsh