FROM debian:10

RUN apt-get update
RUN apt-get install -y nodejs npm
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && \
 apt-get install -y nodejs

USER root
ENV APP_HOME /var/www
COPY ./ $APP_HOME
WORKDIR $APP_HOME
RUN chown -R www-data:www-data $APP_HOME

#--------gcsfuse--------
RUN apt update
RUN apt install sudo -y
RUN apt install curl -y
RUN chmod +x /var/www/gcsfuse_run.sh

RUN set -e; \
    apt-get install -y \
    gnupg \
    tini \
    lsb-release; \
    gcsFuseRepo=gcsfuse-`lsb_release -c -s`; \
    echo "deb http://packages.cloud.google.com/apt $gcsFuseRepo main" | \
    tee /etc/apt/sources.list.d/gcsfuse.list; \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key add -; \
    apt-get update; \
    apt-get install -y gcsfuse \
    && apt-get clean

#CMD [ "node", "app.js" ]

# Use tini to manage zombie processes and signal forwarding
# https://github.com/krallin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

# Pass the startup script as arguments to Tini
CMD ["/var/www/gcsfuse_run.sh"]
