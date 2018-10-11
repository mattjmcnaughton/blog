# Makefile for running development and production blog commands.

GIT_HEAD = "$$(git rev-list HEAD -n 1)"
IMAGE = "mattjmcnaughton/blog:$(GIT_HEAD)"

# Instruct hugo to build our website. All of the built contents of the website
# go into `./public`.
build:
	hugo

build_image: build
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
