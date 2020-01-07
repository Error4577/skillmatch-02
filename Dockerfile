FROM ruby:2.6.3

ARG RAILS_ENV
ARG RAILS_MASTER_KEY

ENV APP_ROOT /app

ENV RAILS_ENV ${RAILS_ENV}
ENV RAILS_MASTER_KEY ${RAILS_MASTER_KEY}

WORKDIR $APP_ROOT

RUN apt-get update && apt-get install -y \
  build-essential \
  default-mysql-client \
  nodejs \
  --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*

ADD Gemfile $APP_ROOT
ADD Gemfile.lock $APP_ROOT

RUN \
  gem install bundler -v 2.1.2 && \
  bundle install && \
  rm -rf ~/.gem

ADD . $APP_ROOT

RUN if [ "${RAILS_ENV}" = "production" ]; then bundle exec rails assets:precompile; else export RAILS_ENV=development; fi

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]