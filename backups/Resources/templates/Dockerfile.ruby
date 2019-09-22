FROM ruby:2.5.0
MAINTAINER Roberto Nogueira <enogrob@gmail.com>

# Deploy Ruby App.
WORKDIR /usr/src/app
ADD Gemfile* ./
RUN bundle install
