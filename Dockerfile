FROM rubylang/ruby:2.7-bionic
RUN apt update && apt install --assume-yes --no-install-recommends curl ca-certificates \
  && curl -sL https://deb.nodesource.com/setup_18.x | bash - \
  && apt update \
  && apt install --assume-yes --no-install-recommends nodejs \
  curl  \
  git   \
  g++   \
  libvips-dev \
  make \
  openssh-server \
  rsync \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /blog

COPY Gemfile Gemfile.lock /blog/
RUN bundle install --jobs 3

COPY package.json package-lock.json /blog/
RUN npm install

COPY . /blog

RUN bundle exec middleman build
