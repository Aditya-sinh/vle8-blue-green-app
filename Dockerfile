FROM nginx:alpine

ARG APP_VERSION=blue

COPY index-blue.html /usr/share/nginx/html/index-blue.html
COPY index-green.html /usr/share/nginx/html/index-green.html

RUN cp /usr/share/nginx/html/index-${APP_VERSION}.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
