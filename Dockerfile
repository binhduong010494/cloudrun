FROM debian:10

RUN apt-get update && \
 apt-get install -y \
    nodejs npm

RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && \
 apt-get install -y nodejs

COPY ./ /var/www

WORKDIR /var/www


CMD [ "node", "app.js" ]
