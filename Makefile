# Makefile for running development and production blog commands.

GIT_HEAD = "$$(git rev-list HEAD -n 1)"

BASE_IMAGE = "mattjmcnaughton/local-caddy-prometheus-base:latest"
IMAGE = "mattjmcnaughton/blog:$(GIT_HEAD)"

# Instruct hugo to build our website. All of the built contents of the website
# go into `./public`.
build:
	hugo

build_base_image:
	docker build --build-arg plugins=prometheus -t $(BASE_IMAGE) github.com/abiosoft/caddy-docker.git

build_image: build build_base_image
	docker build -t $(IMAGE) .

# @TODO(mattjmcnaughton) Automate this as part of a CI/CD pipeline.
publish: build_image
	docker push $(IMAGE)

# @TODO(mattjmcnaughton) Automate this as part of a CI/CD pipeline.
deploy:
	@echo "todo"

# Serve the blog in development.
#
# Updates will be automatically reflected.
serve:
	hugo server -w
