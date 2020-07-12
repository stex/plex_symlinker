module Plex
  module Symlinker
    class Symlink
      attr_reader :path

      def initialize(path)
        @path = path
      end

      def target
        File.readlink(path)
      end
    end
  end
end
