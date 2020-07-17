module Plex
  module Symlinker
    class Operation
      attr_reader :files_base_dir, :symlinks_base_dir, :virtual_files_base_dir

      def initialize(files_base_dir, symlinks_base_dir, virtual_files_base_dir: nil)
        @files_base_dir = files_base_dir
        @symlinks_base_dir = symlinks_base_dir
        @virtual_files_base_dir = virtual_files_base_dir.presence || @files_base_dir
      end

      def files(dir, extensions = FileTypes::AudioFile.registered_types.keys)
        extensions.flat_map do |extension|
          Dir[File.join(dir, "**/*.#{extension}")]
        end
      end

      def audio_files
        files(files_base_dir).map(&FileTypes::AudioFile.method(:from_path))
      end

      def symlinks
        files(symlinks_base_dir).map(&Symlink.method(:new))
      end

      def perform
        cleanup
        create_symlinks
      end

      def create_symlinks
        puts "Creating new symlinks..."

        progress = ProgressBar.create(total: audio_files.size)

        audio_files.each do |file|
          progress.title = "#{file.album_artist.truncate(20)}/#{file.album.truncate(20)}"
          FileUtils.mkdir_p(File.join(symlinks_base_dir, file.relative_symlink_dir))

          path = file.path.gsub(files_base_dir, virtual_files_base_dir)
          symlink_path = File.join(symlinks_base_dir, file.relative_symlink_path)

          next if File.symlink?(symlink_path)

          File.symlink(path, symlink_path)
          progress.increment
        end
      end

      #
      # Removes all symlinks from the target folder that don't have an existing target any more
      #
      def cleanup
        puts "Removing invalid existing symlinks..."
        symlinks.each do |link|
          current_target = link.target.gsub(virtual_files_base_dir, files_base_dir)
          unless File.exist?(current_target)
            File.delete(current_target)
          end
        end
      end
    end
  end
end
