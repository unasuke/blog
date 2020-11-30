FROM unasuke/ruby-nodejs:2.6-nodejs12

WORKDIR /blog

RUN apt update \
  && apt-get install -y --no-install-recommends \
    curl  \
    git   \
    g++   \
    openssh-server \
    rsync \
  && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock /blog/
RUN bundle install --path vendor/bundle --jobs 3

COPY package.json package-lock.json /blog/
RUN npm install

COPY . /blog
