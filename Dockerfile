FROM ruby:slim

RUN apt-get update && \
        apt-get install -y libtag1-dev libtag-extras-dev g++ make && \
        apt-get clean

WORKDIR /app

COPY ./lib/plex_symlinker/version.rb ./lib/plex_symlinker/version.rb
COPY ./Gemfile* ./
COPY ./plex_symlinker.gemspec ./

RUN bundle config set deployment 'true'
RUN bundle install --without=development

COPY ./ ./

CMD bundle exec exe/plex_symlinker /app/source /app/target --symlink-target-dir=${SYMLINK_TARGET_DIR}
