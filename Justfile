image_name := "mattjmcnaughton/blog-builder:latest"
docker_run := "docker run -it -v `pwd`:/site {{image_name}}"

build-image:
  docker build -t {{image_name}} .

build-site:
  docker run -it -v `pwd`:/site --entrypoint sass {{image_name}} --no-source-map public/styles.scss public/styles.css

container-shell:
  docker run -it -v `pwd`:/site {{image_name}}

serve:
  firefox public/index.html
  docker run -it -v `pwd`:/site --entrypoint sass {{image_name}} --no-source-map -w public/styles.scss public/styles.css

deploy:
  docker run -it -v `pwd`:/site {{image_name}} ./deploy.sh
