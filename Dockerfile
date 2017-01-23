FROM ruby:2.3.3
# run update
RUN apt-get update -qq
# install dependencies
RUN apt-get install -y build-essential libpq-dev nodejs mysql-client
# add rails
RUN gem install rails

# make working directory and move files over
RUN mkdir /home/libtool
WORKDIR /home/libtool
ADD . /home/libtool
RUN cd /home/libtool
RUN bundle install
