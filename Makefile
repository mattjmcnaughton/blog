# Makefile for running development and production blog commands.

# The name of our docker blog image.
IMAGE_NAME=mattjmcnaughton/hugo-blog:latest

# The prefix for all development commands using docker.
DEV_DOCKER_PREFIX=docker run --rm -it -v $(shell pwd):/blog $(IMAGE_NAME)

# Build the docker image containing an install of hugo.
build_image:
	docker build -t $(IMAGE_NAME) .

# Start up a bash shell in the container to execute commands.
exec:
	$(DEV_DOCKER_PREFIX) /bin/bash

# Instruct hugo to build our website. All of the built contents of the website
# go into `./public`.
build:
	$(DEV_DOCKER_PREFIX) hugo

# Serve the blog in development.
#
# Updates will be automatically reflected. We bind to `0.0.0.0` because the
# default binding of `127.0.0.1` would allow us to only see the served website
# when we are on the vm hosting Docker.
#
# Access the served blog at `http://DOCKER_MACHINE_IP:1313`.
serve:
	$(DEV_DOCKER_PREFIX) hugo server --bind="0.0.0.0"
