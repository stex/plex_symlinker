require "plex/symlinker/version"

require "rubygems"
require "bundler/setup"
require "active_support/all"
require "taglib"

Gem.find_files("plex/symlinker/**/*.rb").each { |path| require path }

module Plex
  module Symlinker
    class Error < StandardError; end

    def self.load_dir(path)
      Dir[File.join(path, "/**/*.m4b")].map(&AudioFile.method(:new))
    end
  end
end
