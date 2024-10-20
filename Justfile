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
