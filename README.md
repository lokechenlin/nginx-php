# About

A docker container for Nginx-PHP.
* Nginx 1.12.2
* PHP 7.2.10 
* Supervisor 3.3.4
* Port 80 for public site
* Port 81 for internal admin pages
* Port 9001 for supervisor admin page
* Together with Crontab & Logrotate

# Reminder
* Do remember to restrict the access to status & ping in nginx.conf

## To build Docker image

Under the folder with `Dockerfile`. Estimate build time 15-20 min.

Command:

    docker build [OPTIONS] PATH | URL | -

Example:

    docker build -t nginx-php .

## To run Docker container

Command:

    docker run -it [OPTIONS] IMAGE[:TAG|@DIGEST] [COMMAND] [ARG...]

Example:

    docker run -d \
    --cap-add SYS_PTRACE \
    -p 8080:80  -p 8081:81 -p 8082:9001 \
    -v /Users/chenlin/Dev3/localdev/src:/data/www \
    -e ADMIN_PASSWORD=1234 \
    --name nginx-php nginx-php

Remarks:
> Replace `-d` with `-it` to run container in interactive mode.

> `--cap-add` means, Add Linux capabilities

> `SYS_PTRACE` means, The ptrace() system call provides a means by which one process (the "tracer") may observe and control the execution of another process (the "tracee"), and examine and change the tracee's memory and registers.  It is primarily used to implement breakpoint debugging and system call tracing. To fix some error thrown by supervisor.

> `ADMIN_PASSWORD`, use for apc & supervisor admin page 

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


## Todo
* Enable brotli content encoding for nginx
* https://medium.freecodecamp.org/powerful-ways-to-supercharge-your-nginx-server-and-improve-its-performance-a8afdbfde64d