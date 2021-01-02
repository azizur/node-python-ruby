# Base image: Debian 10
FROM debian:buster-slim

LABEL maintainer="https://hub.docker.com/u/azizur"

# Set default timezone for the image
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Node.js lts/erbium
ARG NODE_VERSION=12

# Update base image
RUN apt-get update && apt-get -y upgrade;
RUN apt-get install -y curl build-essential patch ruby-dev zlib1g-dev liblzma-dev git;

RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash -

# Install Python, Ruby and Node.JS packages
RUN apt-get install -y \
  autoconf \
  automake \
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

# create a new user: pipeline
RUN useradd -ms /bin/bash pipeline

# run docker container as: pipeline 
USER pipeline
WORKDIR /home/pipeline
