# Makefile for running development and production blog commands.

# Instruct hugo to build our website. All of the built contents of the website
# go into `./public`.
build:
	hugo

# Create a new blog post.
#
# @EXAMPLE: `make post PATH=post/using-hugo.md`
post:
	hugo new $(PATH)

# Serve the blog in development.
#
# Updates will be automatically reflected.
serve:
	hugo server -w
