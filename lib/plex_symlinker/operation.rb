module PlexSymlinker
  class Operation
    attr_reader :files_base_dir, :symlinks_base_dir, :symlink_target_dir

    #
    # @param [String] files_base_dir
    #   The directory the audio files are in. Sub-Directories are scanned accordingly.
    # @param [String] symlinks_base_dir
    #   The directory the symlinks and folder structure should be placed in.
    # @param [String] symlink_target_dir
    #   In some cases, the created symlinks should not target the actual files directory,
    #   but a different one instead. An example would be the usage of this Gem through a Dockerfile
    #   with mounted volumes.
    #
    # @example Usage with a custom symlink target dir
    #   # When using a docker container to run this gem, we have to make sure it has access to
    #   # both the files and the directory to place the symlinks in. The easiest way to do so
    #   # is by mounting both directories as volumes.
    #   # The docker image expects the files and symlinks directories to be mounted as  /app/source and /app/target
    #   # respectively:
    #
    #   docker run plex-symlinker -v /path/to/audio/files:/app/source -v /path/to/symlinks:/app/target
    #
    #   # The problem here would be that the generated symlinks would all point to files inside /app/source
    #   # instead of the actual audio file directory as this is the only directly that's known inside the
    #   # docker container.
    #   # To fix this, specifying the actual files directory outside the container as +symlink_target_dir+
    #   # takes precedence when creating the symlinks. This is already done in /bin/plex-symlinker-docker.
    #   # An example initialization for the above paths would therefore be:
    #
    #   Operation.new("/app/source", "/app/target", symlink_target_dir: "/path/to/audio/files")
    #
    def initialize(files_base_dir, symlinks_base_dir, symlink_target_dir: nil)
      @files_base_dir = files_base_dir
      @symlinks_base_dir = symlinks_base_dir
      @symlink_target_dir = symlink_target_dir.presence || @files_base_dir
    end

    #
    # Searches for files within the given directory and its subdirectories.
    #
    # @param [String] dir
    #   The directory to search in
    # @param [Array<#to_s>] extensions
    #   File extensions to be taken into account. Only files with a matching extension
    #   will be returned.
    # @return [Array<String>] The paths to all files with matching extensions within the given directory
    #
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
        current_target = link.target.gsub(symlink_target_dir, files_base_dir)
        unless File.exist?(current_target)
          File.delete(current_target)
        end
      end
    end
  end
end
