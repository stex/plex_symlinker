module PlexSymlinker
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
