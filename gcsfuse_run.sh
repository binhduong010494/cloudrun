#!/usr/bin/env bash
set -eo pipefail

echo "Mounting GCS Fuse."
gcsfuse -o rw,allow_other -file-mode=777 -dir-mode=777 --debug_http --debug_gcs --debug_fuse --implicit-dirs --key-file=/var/www/cloud-run.json --only-dir files redmine_storage /var/www/files
echo "Mounting completed."

echo "Rails server."
node app.js
echo "Rails server completed."

# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
# Timeout is set to 0 to disable the timeouts of the workers to allow Cloud Run to handle instance scaling.

# Exit immediately when one of the background processes terminate.
wait -n
