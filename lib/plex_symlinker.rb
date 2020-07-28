require "rubygems"
require "bundler/setup"
require "active_support/all"
require "pathname"
require "ruby-progressbar"
require "taglib"

require "plex_symlinker/file_types/audio_file"
require "plex_symlinker/file_types/mp3"
require "plex_symlinker/file_types/mp4"
require "plex_symlinker/operation"
require "plex_symlinker/symlink"
require "plex_symlinker/version"

module PlexSymlinker
  class Error < StandardError; end

  def self.output
    @output ||= STDOUT
  end

  def self.output=(val)
    @output = val
  end

  def self.logger
    @logger ||= Logger.new(output)
  end
end
