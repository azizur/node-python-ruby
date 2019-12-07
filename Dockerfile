# Base image: Debian 10
FROM debian:buster-slim

LABEL maintainer="https://hub.docker.com/u/azizur"

# Node.js lts/erbium
ARG NODE_VERSION=12

# Update base image
RUN apt-get update && apt-get -y upgrade;
RUN apt-get install -y curl build-essential patch ruby-dev zlib1g-dev liblzma-dev git;

RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash -

# Install Python, Ruby and Node.JS packages
RUN apt-get install -y \
  python3 \
  python3-pip \
  ruby-full \
  nodejs

RUN ln -sf /usr/bin/python3 /usr/bin/python; \
  ln -sf /usr/bin/pip3 /usr/bin/pip;

# Python awscli and pipenv support
RUN pip install awscli pipenv

# Ruby bundler support
RUN gem install bundler
