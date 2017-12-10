FROM unasuke/ruby-nodejs:2.4.2-nodejs8

WORKDIR /blog

RUN apt update && apt install --assume-yes rsync && rm -rf /var/lib/apt/lists/*

COPY package.json package-lock.json /blog/
RUN npm install

COPY Gemfile Gemfile.lock /blog/
RUN bundle install --jobs=4 --path vendor/bundle

COPY . /blog
