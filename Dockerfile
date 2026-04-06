# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.3.5
FROM docker.io/library/ruby:$RUBY_VERSION-slim

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libvips libyaml-dev pkg-config sqlite3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV RAILS_ENV=development \
    BUNDLE_PATH=/usr/local/bundle

COPY vendor/* ./vendor/
COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
