FROM unasuke/ruby-nodejs:2.7-nodejs14

WORKDIR /blog

RUN apt update \
  && apt-get install -y --no-install-recommends \
    curl  \
    git   \
    g++   \
    openssh-server \
    rsync \
  && rm -rf /var/lib/apt/lists/*

RUN bundle config set --global path vendor/bundle
COPY Gemfile Gemfile.lock /blog/
RUN bundle install --jobs 3

COPY package.json package-lock.json /blog/
RUN npm install

COPY . /blog
