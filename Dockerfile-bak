FROM debian:10

RUN apt-get update
RUN apt-get install -y dirmngr gnupg vim
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
RUN apt-get install -y apt-transport-https ca-certificates
RUN sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger buster main > /etc/apt/sources.list.d/passenger.list'
RUN apt update
RUN apt install sudo -y
RUN apt install curl wget ruby-dev mariadb-server libmariadb-dev git imagemagick ghostscript build-essential patch zlib1g-dev liblzma-dev nginx libnginx-mod-http-passenger certbot python3-certbot-nginx -y

COPY ./ /var/www
ENV APP_HOME /var/www/redmine
ENV REDMINE_SECRET_KEY_BASE supersecretkey
ENV TZ Asia/Ho_Chi_Minh

WORKDIR $APP_HOME
RUN chown -R www-data:www-data $APP_HOME
RUN sudo gem update --system 3.2.3
RUN sudo gem install bundler
RUN bundle install
RUN bundle exec rake generate_secret_token



#RUN apt update
#RUN apt install sudo -y
#RUN apt install curl -y

#--------MOUNT TO BUCKET--------
#RUN set -e; \
#    apt-get install -y \
#    gnupg \
#    tini \
#    lsb-release; \
#    gcsFuseRepo=gcsfuse-`lsb_release -c -s`; \
#    echo "deb http://packages.cloud.google.com/apt $gcsFuseRepo main" | \
#    tee /etc/apt/sources.list.d/gcsfuse.list; \
#    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
#    apt-key add -; \
#    apt-get update; \
#    apt-get install -y gcsfuse \
#    && apt-get clean

# Set fallback mount directory
#ENV MNT_DIR /var/www/redmine/files
#ENV BUCKET kyna_demo_bucket

# Copy local code to the container image.
#ENV APP_HOME /var/www/redmine
#WORKDIR $APP_HOME

#RUN gcsfuse --debug_gcs --debug_fuse $BUCKET $MNT_DIR

CMD bundle exec rails server webrick -e production

# Ensure the script is executable
#RUN chmod +x /var/www/gcsfuse_run.sh

# Use tini to manage zombie processes and signal forwarding
# https://github.com/krallin/tini
# ENTRYPOINT ["/usr/bin/tini", "--"]

# Pass the startup script as arguments to Tini
#CMD ["/var/www/gcsfuse_run.sh"]
# [END cloudrun_fuse_dockerfile]
