FROM debian:bookworm-slim

WORKDIR /mastodon

ENV \
  RAILS_ENV="development" \
  NODE_ENV="development" \
  RAILS_SERVE_STATIC_FILES="true" \
  BIND="0.0.0.0" \
  DEBIAN_FRONTEND="noninteractive" \ 
  PATH=/root/.rbenv/shims:/root/.rbenv/bin:/usr/local/sbin::$PATH

COPY ./mastodon /mastodon/

RUN apt-get update \
 && apt-get install -y \
    git \
    curl \
    # rbenv dependencies
    # https://github.com/rbenv/ruby-build/wiki#ubuntudebianmint
    autoconf \
    patch \
    build-essential \
    rustc \
    libssl-dev \
    libyaml-dev \
    libreadline6-dev \
    zlib1g-dev \
    libgmp-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm6 \
    libgdbm-dev \
    libdb-dev \
    uuid-dev \
    # mastodon dependencies
    libidn11-dev \
    imagemagick \
    ffmpeg \
    file \
    libpq-dev \
    libvips \
    libvips-dev \
    # dev tools
    rbenv \
    # ruby-build \
    ruby-foreman

RUN git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build \
 && rbenv install

RUN bundle config git.allow_insecure true \
 && bundle install

# https://github.com/nodesource/distributions/blob/master/README.md
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
 && apt-get install -y nodejs

RUN corepack enable yarn \
 && yarn workspaces focus --production @mastodon/mastodon

RUN bundle exec rails assets:precompile

EXPOSE 3000 4000
