FROM ruby:slim

ARG USER_ID
ARG GROUP_ID

RUN addgroup --gid $GROUP_ID user || echo "Group already exists"
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user

RUN apt-get update && \
        apt-get install -y libtag1-dev libtag-extras-dev g++ make

USER user
ENV WORKDIR /home/user

WORKDIR $WORKDIR

COPY ./lib/plex/symlinker/version.rb ./lib/plex/symlinker/version.rb
COPY ./Gemfile* ./
COPY ./plex-symlinker.gemspec ./

RUN bundle install

COPY ./ ./

CMD ["bundle", "exec", "$WORKDIR/exe/plex-symlinker", "$WORKDIR/source", "$WORKDIR/target"]
