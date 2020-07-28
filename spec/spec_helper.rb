require "bundler/setup"
require "plex_symlinker"
require "pathname"
require "rspec/its"
require "pry"

module Helpers
  def spec_root
    Pathname.new(__dir__)
  end

  def resource_file(filename)
    spec_root.join("resources", filename)
  end

  def resource_files
    spec_root.join("resources").children
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Helpers
end
