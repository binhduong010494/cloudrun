#!/usr/bin/env bash
set -eo pipefail

# Create mount directory for service
mkdir -p $FILES_DIR
mkdir -p $PLUGINS_DIR

echo "Mounting GCS Fuse."
gcsfuse --debug_gcs --debug_fuse $BUCKET/files $FILES_DIR
gcsfuse --debug_gcs --debug_fuse $BUCKET/plugins $PLUGINS_DIR
echo "Mounting completed."

# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 2 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
# Timeout is set to 0 to disable the timeouts of the workers to allow Cloud Run to handle instance scaling.
exec gunicorn --bind :$PORT --workers 1 --threads 2 --timeout 0 main:app &

# Exit immediately when one of the background processes terminate.
wait -n