FROM unasuke/ruby-nodejs:2.6-nodejs12

WORKDIR /blog

RUN apt update \
  && apt install --assume-yes --no-install-recommends \
    g++   \
    rsync \
  && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock /blog/
RUN bundle install

COPY package.json package-lock.json /blog/
RUN npm install

COPY . /blog
