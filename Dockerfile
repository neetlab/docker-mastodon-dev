FROM ruby:3.0.5-slim

WORKDIR /mastodon

ENV RAILS_ENV="development" \
    NODE_ENV="development" \
	RAILS_SERVE_STATIC_FILES="true" \
    BIND="0.0.0.0"

COPY . /mastodon/

RUN apt-get update \
 && apt-get install -y \
	git \
	build-essential \
	imagemagick \
	ffmpeg \
	file \
 	libicu-dev \
	libidn11-dev \
	ubuntu-dev-tools \
	libpq-dev \
	curl \
	ruby-foreman

RUN bundle config git.allow_insecure true \
 && bundle install

# https://github.com/nodesource/distributions/blob/master/README.md
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
 && apt-get install -y nodejs

RUN npm install --global yarn
RUN yarn install --forzen-lockfile
RUN bundle exec rails assets:precompile

EXPOSE 3000 4000