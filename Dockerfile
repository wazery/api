FROM ruby:2.2.3
RUN apt-get update && apt-get install -y nodejs

ENV APP_HOME /hackhub
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME
