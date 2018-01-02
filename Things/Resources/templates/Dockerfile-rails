FROM ruby:2.3.3
MAINTAINER Roberto Nogueira <roberto.nogueira@atlanticsolutions.com.br>

# Install build-essential and nodejs.
RUN apt-get update \
  && apt-get install -y build-essential libpq-dev nodejs --no-install-recommends \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN mkdir /deep_space_9
WORKDIR /deep_space_9
ADD Gemfile /deep_space_9/Gemfile
ADD Gemfile.lock /deep_space_9/Gemfile.lock
RUN bundle install
ADD . /deep_space_9
