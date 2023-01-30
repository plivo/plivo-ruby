FROM ruby:3.0.1-alpine

RUN apk update && apk add git vim bash make gcc musl-dev

WORKDIR /usr/src/app
RUN gem install json --source 'https://rubygems.org/'

# Copy setup script
COPY setup_sdk.sh /usr/src/app/
RUN chmod a+x /usr/src/app/setup_sdk.sh

ENTRYPOINT [ "/usr/src/app/setup_sdk.sh" ]