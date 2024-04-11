#!/bin/bash

hut init

sass --no-source-map public/styles.scss public/styles.css

tar -C public -cvz . > site.tar.gz

target_urls=("mattjmcnaughton.com" "blog.mattjmcnaughton.com")

for url in "${target_urls[@]}";
do
  hut pages publish -d $url site.tar.gz
done

