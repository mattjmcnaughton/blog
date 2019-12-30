# Instruct hugo to build our website. All of the built contents of the website
# go into `./public`.
build:
	hugo

# Serve the blog in development.
#
# Updates will be automatically reflected.
serve:
	hugo server -w
