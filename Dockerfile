FROM ruby:3.0.5-slim
# FROM node:16

WORKDIR /opt/mastodon

ENV RAILS_ENV="development" \
    NODE_ENV="development"

COPY . /opt/mastodon/

RUN apt-get update \
 && apt-get install -y \
	git \
 	libicu-dev \
	libidn11-dev

RUN bundle config git.allow_insecure true \
 && bundle install
#  && bundle exec rails db:setup \
#  && bundle exec rails assets:precompile