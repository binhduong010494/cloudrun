#!/bin/sh
docker-compose down
docker-compose stop
docker-compose up --build
