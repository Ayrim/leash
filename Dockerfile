from ruby:2.4-alpine3.7

LABEL maintainer="ayrton.vercruysse@gmail.com"
RUN apk add --no-cache \
  nodejs \
  nodejs-npm \
  yarn


ENV RUNTIME_DEPS imagemagick file tzdata postgresql
ENV BUILD_DEPS build-base curl-dev git libxml2-dev libxslt-dev postgresql-dev

ENV APP_HOME /srv

RUN apk add --no-cache $BUILD_DEPS $RUNTIME_DEPS

# https://github.com/pry/pry/issues/1248
RUN apk add --no-cache --update less

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

RUN bundle install --jobs 4 --retry 5

ADD . $APP_HOME

ARG port=3000
EXPOSE $port

CMD ["bundle", "exec", "puma", "-p", "$port", "-C", "./config/puma.rb"]
