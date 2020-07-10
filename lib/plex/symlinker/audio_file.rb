module Plex
  module Symlinker
    class AudioFile
      attr_reader :path

      MAPPINGS = {
        sorting_album_artist: "soaa",
        sorting_artist: "soar",
        sorting_album: "soal",
        album: "©alb",
        genre: "©gen",
        title: "©nam",
        year: "©day",
        performer: "----:com.apple.iTunes:PERFORMER",
        track_number: "trkn"
      }

      MAPPINGS.each do |k, v|
        define_method(k) do
          tags[v]
        end
      end

      def initialize(path)
        @path = path
      end

      def tags
        @tags ||= TagLib::MP4::File.open(path) do |file|
          Hash[file.tag.item_map.to_a.map { |k, i| [k, i.to_string_list.first] }]
        end
      end

      def album_artist
        tags["----:com.apple.iTunes:ALBUM ARTIST"] || tags["aART"]
      end

      def symlink_file_name
        # return "#{[track_number, title].join(" - ")}.m4b" if track_number && title
        File.basename(path)
      end

      def relative_symlink_dir
        "#{album_artist}/#{album}"
      end

      def relative_symlink_path
        "#{relative_symlink_dir}/#{symlink_file_name}"
      end

      def symlink!(base_dir)
        FileUtils.mkdir_p(File.join(base_dir, relative_symlink_dir))
        File.symlink(path, File.join(base_dir, relative_symlink_path))
      end

      # => {"----:com.apple.iTunes:ALBUM ARTIST"=>"Walter Moers",
      #     "----:com.apple.iTunes:Encoding Params"=>"Nero AAC codec / Aug 6 2007",
      #     "----:com.apple.iTunes:PERFORMER"=>"Andreas Fröhlich",
      #     "----:com.apple.iTunes:cdec"=>"Nero AAC codec / Aug 6 2007",
      #     "----:com.apple.iTunes:tool"=>"Nero AAC codec / Aug 6 2007",
      #     "aART"=>"Walter Moers",
      #     "covr"=>nil,
      #     "soaa"=>"Moers, Walter",
      #     "soal"=>"05 - Der Schrecksenmeister",
      #     "soar"=>"Moers, Walter",
      #     "trkn"=>nil,
      #     "©ART"=>"Walter Moers",
      #     "©alb"=>"Der Schreckensmeister",
      #     "©day"=>"2008",
      #     "©gen"=>"Hörbuch",
      #     "©nam"=>"Der Schreckensmeister - Teil 1",
      #     "©too"=>"Nero AAC codec / Aug 6 2007"}
    end
  end
end
