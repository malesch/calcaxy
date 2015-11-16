FROM ruby:1.9.3-p551-slim
MAINTAINER malex <malex@calclab.com>

RUN useradd -m -d /calcaxy calcaxy

RUN apt-get update -qq && apt-get install -y \
    libmysqld-dev \
    build-essential \
    libmagick++-dev

RUN mkdir -p /calcaxy
WORKDIR /calcaxy
ADD Gemfile /calcaxy/
ADD Gemfile.lock /calcaxy/
RUN bundle install

# Add the rails app
WORKDIR /calcaxy
ADD . /calcaxy
RUN chown -R calcaxy /calcaxy
RUN ln -s public/archives /site-archive
#RUN ln -s public/firstbox  public/archive/father_son
RUN ln -s public/files /xymedia

#USER calcaxy
CMD ["/calcaxy/script/server"]
