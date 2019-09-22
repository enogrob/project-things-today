FROM elixir:1.6
MAINTAINER Roberto Nogueira <enogrob@gmail.com>

# Deploy Elixir App.
WORKDIR /usr/src/app
ADD . ./
RUN mix local.hex --force
RUN mix deps.get
