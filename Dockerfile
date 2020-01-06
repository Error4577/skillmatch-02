FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y build-essential nodejs
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN \
  gem install bundler -v 2.1.2 && \
  bundle install && \
  rm -rf ~/.gem
COPY . /app
