FROM mattjmcnaughton/local-caddy-prometheus-base:latest

COPY public /srv
COPY Caddyfile /etc/Caddyfile
