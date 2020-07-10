FROM ruby:slim

RUN apt-get update && \
        apt-get install -y libtag1-dev libtag-extras-dev g++ make

ENV WORKDIR /app

WORKDIR $WORKDIR

COPY ./lib/plex/symlinker/version.rb ./lib/plex/symlinker/version.rb
COPY ./Gemfile* ./
COPY ./plex-symlinker.gemspec ./

RUN bundle install

COPY ./ ./

CMD ["sh" "-c" "bundle", "exec", "${WORKDIR}/exe/plex-symlinker", "${WORKDIR}/source", "${WORKDIR}/target"]
