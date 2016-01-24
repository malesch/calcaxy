FROM ruby:1.9.3-p551-slim
MAINTAINER malex <malex@calclab.com>

RUN useradd -m -d /calcaxy calcaxy

RUN apt-get update \
    && apt-get install -y libmysqld-dev \
    build-essential \
    libmagick++-dev

# Run Bundle in a cache efficient way
WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
RUN bundle install

# Add the rails app
WORKDIR /calcaxy
ADD . /calcaxy

#USER calcaxy
CMD ["/calcaxy/script/server"]
