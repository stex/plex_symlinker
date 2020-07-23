module PlexSymlinker
  module FileTypes
    class AudioFile
      class << self
        def registered_types
          @registered_types ||= {}
        end

        def register_type(extension, klass)
          registered_types[extension.to_s] = klass
        end

        def tag_reader(method_name, tag)
          define_method(method_name) do
            tags[tag.to_s]
          end
        end

        def from_path(path)
          extension = File.extname(path)[1..-1]
          registered_types[extension.to_s]&.new(path) || fail(ArgumentError, "No type handler registered for extension '#{extension}'")
        end
      end

      attr_reader :path

      def initialize(path)
        @path = path
      end

      def tags
        fail NotImplementedError
      end

      def album
        fail NotImplementedError
      end

      def genre
        fail NotImplementedError
      end

      def title
        fail NotImplementedError
      end

      def year
        fail NotImplementedError
      end

      def artist
        fail NotImplementedError
      end

      def album_artist
        fail NotImplementedError
      end

      def track_number
        fail NotImplementedError
      end

      def symlink_file_name
        File.basename(path)
      end

      def relative_symlink_dir
        "#{album_artist}/#{album}"
      end

      def relative_symlink_path
        "#{relative_symlink_dir}/#{symlink_file_name}"
      end
    end
  end
end
