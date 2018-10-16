# About

A docker container for Nginx-PHP
* Do remember to change the apc.php password.
* Do remember to restrict the access to status & ping in nginx.conf

## To build Docker image

Under the folder with `Dockerfile`

Command:

    docker build [OPTIONS] PATH | URL | -

Example:

    docker build -t nginx-php .

## To run Docker container in interaction mode
Interaction mode for development setup

Command:

    docker run -it [OPTIONS] IMAGE[:TAG|@DIGEST] [COMMAND] [ARG...]

Example:

    docker run -it \
    --cap-add SYS_PTRACE \
    -p 8081:80 \
    -p 28081:9001 \
    -v /Users/chenlin/Dev3/localdev/src:/data/src \
    --name nginx-php nginx-php

Remarks:
> `--cap-add` means, Add Linux capabilities

> `SYS_PTRACE` means, The ptrace() system call provides a means by which one process (the "tracer") may observe and control the execution of another process (the "tracee"), and examine and change the tracee's memory and registers.  It is primarily used to implement breakpoint debugging and system call tracing. To fix some error thrown by supervisor.

## To run Docker container in detach mode
Detach mode for production setup

Command:

    docker run -d [OPTIONS] IMAGE[:TAG|@DIGEST] [COMMAND] [ARG...]

Example:

    docker run -d \
    --cap-add SYS_PTRACE \
    --restart=always \
    -p 8081:80 \
    -p 28081:9001 \
    -v /Users/chenlin/Dev3/localdev/src:/data/src \
    --name nginx-php nginx-php


## To login to container
First, find the container ID:

    docker ps

Then, login to the container

Command:

    docker exec -it CONTAINER bash

Example:

    docker exec -it nginx-php bash 

## To copy file/folders between a container and the local filesystem
Command:

    docker cp [OPTIONS] CONTAINER:PATH LOCALPATH | -
    docker cp [OPTIONS] LOCALPATH | - CONTAINER:PATH

Example:

    docker cp nginx-php:/etc/nginx/nginx.conf /vagrant/nginx.conf

## Clean up inactive container
Command:

    docker rm $(docker ps -a -q)
