FROM debian:10

RUN apt-get update
#RUN apt-get install -y dirmngr gnupg vim
#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
#RUN apt-get install -y apt-transport-https ca-certificates
#RUN sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger buster main > /etc/apt/sources.list.d/passenger.list'
#RUN apt update
#RUN apt install sudo -y
#RUN apt install curl wget ruby-dev mariadb-server libmariadb-dev git imagemagick ghostscript build-essential patch zlib1g-dev liblzma-dev nginx libnginx-mod-http-passenger certbot python3-certbot-nginx -y

#COPY ./ /var/www
#ENV APP_HOME /var/www/redmine
#ENV REDMINE_SECRET_KEY_BASE supersecretkey
#ENV TZ Asia/Ho_Chi_Minh
#
#WORKDIR $APP_HOME
#RUN chown -R www-data:www-data $APP_HOME
#RUN gem update --system 3.2.3
#RUN sudo gem install bundler
#RUN bundle install
#RUN bundle exec rake generate_secret_token

#CMD bundle exec rails server webrick -e production

RUN apt update
RUN apt install sudo -y
RUN apt install curl -y

#--------MOUNT TO BUCKET--------
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


CMD tail -f

#---
#RUN gcloud auth activate-service-account --key-file /var/www/white-caster-347304-bce2fd90dfb3.json
#RUN echo "Mounting GCS Fuse."
#RUN gcsfuse --debug_gcs --debug_fuse --only-dir /var/www/redmine/files ruby_storage files
#RUN echo "Mounting completed."

#
#ENV MNT_DIR /var/www/redmine/files
#ENV BUCKET ruby_storage/files

#RUN echo "Mounting GCS Fuse."
#RUN gcsfuse --debug_gcs --debug_fuse $BUCKET $MNT_DIR
#RUN echo "Mounting completed."
