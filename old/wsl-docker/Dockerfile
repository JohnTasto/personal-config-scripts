FROM nginx:alpine
COPY nginx-cert.conf /etc/nginx/conf.d/nginx-cert.conf
COPY .docker/daemon /tls/
RUN sed -i 's/user\s*nginx;/user root;/g' /etc/nginx/nginx.conf
