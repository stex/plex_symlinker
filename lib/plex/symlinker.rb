require "plex/symlinker/version"

require "rubygems"
require "bundler/setup"
require "active_support/all"
require "pathname"
require "ruby-progressbar"
require "taglib"

Gem.find_files("plex/symlinker/**/*.rb").each { |path| require path }

module Plex
  module Symlinker
    class Error < StandardError; end
  end
end
