require "rubygems"
require "bundler/setup"
require "active_support/all"
require "pathname"
require "ruby-progressbar"
require "taglib"
require "zeitwerk"

Zeitwerk::Loader.for_gem.setup

module PlexSymlinker
  class Error < StandardError; end
end
