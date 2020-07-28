require "rubygems"
require "bundler/setup"
require "active_support/all"
require "pathname"
require "ruby-progressbar"
require "taglib"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.setup
loader.eager_load

module PlexSymlinker
  class Error < StandardError; end

  def self.logger
    @logger ||= Logger.new("/dev/null")
  end

  def self.logger=(logger)
    @logger = logger
  end
end
