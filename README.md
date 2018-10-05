# About

A docker container for Nginx-PHP

## To build Docker image

Under the folder with `Dockerfile`

Command:

    docker build [OPTIONS] PATH | URL | -

Example:

    docker build -t php .

## To run Docker container in interaction mode
Interaction mode for development setup

Command:

    docker run -it [OPTIONS] IMAGE[:TAG|@DIGEST] [COMMAND] [ARG...]

Example:

    docker run -d \
    --cap-add SYS_PTRACE \
    -p 8081:80 \
    -p 28081:9001 \
    -p 18081:8008 \
    -v /Users/chenlin/Dev3/localdev/src:/data/src \
    --name php-nginx1 php

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
    -p 18081:8008 \
    -v /docker/papi/data:/data \
    -v /docker/config/papi-local.conf:/etc/nginx/conf.d/papi.conf \
    --name papi chenlin/papi-container

Remarks:

> `--restart=always` means, always restart the container regardless of the exit status. When you specify always, the Docker daemon will try to restart the container indefinitely. The container will also always start on daemon startup, regardless of the current state of the container.

## To login to container
First, find the container ID:

    docker ps

Then, login to the container
Command:

    docker exec -it CONTAINER /bin/bash

Example:

    docker exec -it b9584c8a4893 /bin/bash # Using container id
    docker exec -it papi /bin/bash # Using container name

## To copy file/folders between a container and the local filesystem
Command:

    docker cp [OPTIONS] CONTAINER:PATH LOCALPATH | -
    docker cp [OPTIONS] LOCALPATH | - CONTAINER:PATH

Example:

    docker cp papi:/etc/nginx/nginx.conf /vagrant/nginx.conf

## Clean up inactive container
You may need higher specification for vagrant instance, i.e. 4 cores and 2 GB RAM

    docker rm $(docker ps -a | grep '2 days ago' | awk '{print $1}')

OR remove all

    docker rm $(docker ps -a -q)

# Contributing To PAPI Container

Please refer to [Contribution Guideline](https://github.com/seekasia/papi-container/blob/master/CONTRIBUTING.md).
