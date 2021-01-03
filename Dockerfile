# Base image: Debian 10
FROM debian:buster-slim

LABEL maintainer="@azizur"

# Node.js lts/erbium
ARG NODE_VERSION=lts/erbium

# Update base image
RUN apt-get update && apt-get -y upgrade;
RUN apt-get install -y locales curl build-essential patch ruby-dev zlib1g-dev liblzma-dev git;

# Set locale and default timezone for the image
ENV TZ=Europe/London
RUN locale-gen en_GB.UTF-8 && \
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install Python, Ruby and Node.JS packages
RUN apt-get install -y \
  autoconf \
  automake \
  python3 \
  python3-pip \
  ruby-full

RUN ln -sf /usr/bin/python3 /usr/bin/python; \
  ln -sf /usr/bin/pip3 /usr/bin/pip;

# Python awscli and pipenv support
RUN pip install awscli pipenv

# Ruby bundler support
RUN gem install bundler

# Add user "pipeline" as non-root user
RUN useradd -ms /bin/bash pipeline

# Copy and set permission for nvm directory
# COPY . /home/pipeline/.nvm/
# RUN chown pipeline:pipeline -R "home/pipeline/.nvm"

# Set sudoer for "pipeline"
RUN echo 'pipeline ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Switch to user "pipeline" from now
USER pipeline

RUN git config --global user.name "pipeline docker" && \
  git config --global user.email "pipeline@docker.container"

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

# nvm
RUN echo 'export NVM_DIR="$HOME/.nvm"'                                       >> "$HOME/.bashrc"
RUN echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> "$HOME/.bashrc"
RUN echo '[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion' >> "$HOME/.bashrc"

# nodejs and tools
RUN bash -c 'source $HOME/.nvm/nvm.sh   && \
  nvm install ${NODE_VERSION}  && \
  nvm use ${NODE_VERSION} && \
  nvm alias default ${NODE_VERSION}'

# Set WORKDIR to nvm directory
WORKDIR /home/pipeline

SHELL ["/bin/bash", "--login", "-c"]

# ENTRYPOINT ["/bin/bash"]
