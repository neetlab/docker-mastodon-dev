#!/bin/bash
docker run --rm -it --env-file ./.env neetshin/mastodon-dev:latest bash -c "RAILS_ENV=production ${@}"