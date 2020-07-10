FROM ruby:slim

RUN apt-get update && \
        apt-get install -y libtag1-dev libtag-extras-dev g++ make

WORKDIR /app
COPY ./lib/plex/symlinker/version.rb ./lib/plex/symlinker/version.rb
COPY ./Gemfile* ./
COPY ./plex-symlinker.gemspec ./

RUN bundle install

COPY ./ ./

CMD ["bundle", "exec", "/app/exe/plex-symlinker", "/app/source", "/app/target"]
