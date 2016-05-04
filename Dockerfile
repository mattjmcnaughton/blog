# Dockerfile providing the environment necessary to run `hugo` from the command
# line.

FROM golang:1.6

MAINTAINER mattjmcnaughton@gmail.com

# Set the Environment variables.
ENV GOPATH /go
ENV PATH /go/bin:$PATH

# Install pygments - the only dependency for Hugo.
RUN apt-get -y update
RUN apt-get -y install python-pygments

# Install hugo.
RUN go get -u -v github.com/spf13/hugo

# Copy the local directory into `/blog`.
ADD . /blog

# Set `/blog` as the workdir.
WORKDIR /blog

# Expose port 1313 when serving `hugo` locally.
EXPOSE 1313
