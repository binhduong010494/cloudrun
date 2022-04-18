FROM debian:10

RUN set -e; \
    apt-get update -y && apt-get install -y \
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

COPY ./ /var/www
ENV APP_HOME /var/www/redmine
ENV REDMINE_SECRET_KEY_BASE supersecretkey
ENV TZ Asia/Ho_Chi_Minh
ENV FILES_DIR $APP_HOME/files
ENV PLUGINS_DIR $APP_HOME/plugins

WORKDIR $APP_HOME
RUN chown -R www-data:www-data $APP_HOME
RUN gem update --system 3.2.3
RUN sudo gem install bundler
RUN bundle install
RUN bundle exec rake generate_secret_token

CMD bundle exec rails server webrick -e production

RUN chmod +x /var/www/gcsfuse_run.sh

# Use tini to manage zombie processes and signal forwarding
# https://github.com/krallin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

# Pass the startup script as arguments to Tini
CMD ["/var/www/gcsfuse_run.sh"]
