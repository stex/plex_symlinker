FROM ruby:slim

RUN apt-get update && \
        apt-get install -y libtag1-dev libtag-extras-dev g++ make

WORKDIR /app

COPY plex_symlinker ./lib/plex/symlinker/version.rb
COPY ./Gemfile* ./
COPY ./plex-symlinker.gemspec ./

RUN bundle install

COPY ./ ./

CMD bundle exec exe/plex-symlinker /app/source /app/target --virtual-files-directory=${VIRTUAL_FILES_DIRECTORY}
