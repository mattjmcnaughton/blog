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

# Create a new blog post.
#
# @EXAMPLE: `make post PATH=post/using-hugo.md`
post:
	$(DEV_DOCKER_PREFIX) hugo new $(PATH)

# Serve the blog in development.
#
# Updates will be automatically reflected.
# Internal links within hugo explicitly reference `localhost`, so for the time
# being I can't think of how to run this within a Docker container. Thus, `hugo`
# is a dependency for development (which makes sense).
#
# @TODO Containerize this as well - need to fix `hugo` hardlinking to localhost.
serve:
	hugo server
