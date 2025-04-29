develop:
    nix develop

build:
    hugo

docker_build: build
    docker build -t docker.io/mattjmcnaughton/blog:latest .

docker_run: docker_build
    docker run -it -p 8080:80 docker.io/mattjmcnaughton/blog:latest

serve:
    hugo serve

launch: build
    fly launch

deploy: build
    fly deploy

update_favicon INPUT_FILE:
    @echo "Generating favicon.ico from {{INPUT_FILE}} → static/favicon.ico"
    convert \
      {{INPUT_FILE}} \
      -gravity center -crop 1:1 +repage \
      -resize 16x16 \
      static/favicon.ico

