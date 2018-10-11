# This Dockerfile builds the image from which we run a container to serve my
# static blog. We utilize a multi-stage build to download two separate binaries
# in an isolated environment, before using a distroless base image for the final
# image which contains just our binaries, configuration, and static content to
# serve. Using the distroless base image with minimal dependencies ensures we
# have the smallest possible image, which is useful with respect to storage and
# minimizing attack surface.

# Based on https://github.com/abiosoft/caddy-docker/blob/master/builder/Dockerfile
FROM golang:1.10-alpine as parent_builder

# Necessary for `go get ...`
RUN apk add --no-cache git gcc musl-dev
# We use this tool as it is also used in
# https://github.com/abiosoft/caddy-docker/blob/master/Dockerfile.
# @TODO(mattjmcnaughton) Are there any disadvantages to just running `caddy`
# directly?
RUN go get -v github.com/abiosoft/parent

# Use a "fuller" base image so the bash script we're executing does not have any
# missing dependencies. As this is a multi-stage build, there is no penalty for
# utilizing a larger base image for an intermediary step.
FROM ubuntu:18.04 as caddy_builder

# Ensure we install gnupg as the bash script will use it to validate our
# install.
RUN apt update && apt install curl gnupg -y

# Follow instructions from https://caddyserver.com/download
RUN curl https://getcaddy.com | bash -s personal http.prometheus

# Validate Caddy working as expected
RUN /usr/local/bin/caddy -version
RUN /usr/local/bin/caddy -plugins

# Use the smallest possible base image
FROM gcr.io/distroless/base

WORKDIR /srv
EXPOSE 80

# Copy binaries from the previous states in our multi-stage build.
COPY --from=parent_builder /go/bin/parent /bin/parent
COPY --from=caddy_builder /usr/local/bin/caddy /bin/caddy

# We bake the Caddyfile and the content into the image, as opposed to mounting
# them at runtime as volumes. Incorporating all relevant information in the
# image makes interacting with containers derived from this image simpler, and
# also makes it easier to perform true "rollbacks" with Kubernetes.
COPY Caddyfile /etc/Caddyfile
COPY public /srv

# As described in
# https://www.ctl.io/developers/blog/post/dockerfile-entrypoint-vs-cmd/, use
# ENTRYPOINT in combination with CMD to specify a default executable, as well as
# default arguments to said executable which may be overwritten by the user
# during `docker run`.
ENTRYPOINT ["/bin/parent", "/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout", "--agree=false"]
