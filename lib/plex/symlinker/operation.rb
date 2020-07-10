module Plex
  module Symlinker
    class Operation
      attr_reader :files_base_dir, :symlinks_base_dir, :virtual_files_base_dir, :extension

      def initialize(files_base_dir, symlinks_base_dir, extension: "m4b", virtual_files_base_dir: nil)
        @files_base_dir = files_base_dir
        @symlinks_base_dir = symlinks_base_dir
        @virtual_files_base_dir = virtual_files_base_dir.presence || @files_base_dir
        @extension = extension
      end

      def files
        Dir[File.join(files_base_dir, "**/*.#{extension}")].map(&AudioFile.method(:new))
      end

      def create_symlinks
        progress = ProgressBar.create(total: files.size)

        files.each do |file|
          progress.title = "#{file.album_artist.truncate(20)}/#{file.album.truncate(20)}"
          FileUtils.mkdir_p(File.join(symlinks_base_dir, file.relative_symlink_dir))

          path = file.path.gsub(files_base_dir, virtual_files_base_dir)
          File.symlink(path, File.join(symlinks_base_dir, file.relative_symlink_path))
          progress.increment
        end
      end
    end
  end
end
