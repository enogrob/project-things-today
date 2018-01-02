FROM ruby:2.3.1
MAINTAINER Roberto Nogueira <roberto.nogueira@atlanticsolutions.com.br>

# Install dependencies.
RUN apt-get update \
  # build-essential
  && apt-get install -y build-essential --no-install-recommends \
  # nodejs and npm
  && apt-get install -y nodejs nodejs-legacy npm --no-install-recommends \
  # postgresql
  && apt-get install -y libpq-dev --no-install-recommends \
  # capybara-webkit
  && apt-get install -y libqt4-dev libqtwebkit-dev --no-install-recommends \
  # rmagick
  && apt-get install -y imagemagick libmagickwand-dev --no-install-recommends \
  # cleanup
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Deploy Rails App.
WORKDIR /usr/src/app
COPY . ./
COPY sample.env .env
RUN gem install bundler && bundle install && npm install
