#start with the base ruby image
FROM ruby:2.7.6-buster
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y install \
  iputils-ping \
  vim \
  ack \
  man-db
  # chromium
  
#make sure we have a folder called /app
RUN mkdir /app

#cd into our app folder each time we start up
WORKDIR /app

#copy our Gemfile and Gemfile.lock
COPY Gemfile* /app/

#install the gems
RUN bundle config set force_ruby_platform true && bundle

CMD cucumber
