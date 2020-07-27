module PlexSymlinker
  module FileTypes
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

    class Mp4 < AudioFile
      tag_reader :sort_album_artist, "soaa"
      tag_reader :sort_artist, "soar"
      tag_reader :sort_album, "soal"
      tag_reader :album, "©alb"
      tag_reader :genre, "©gen"
      tag_reader :title, "©nam"
      tag_reader :year, "©day"
      tag_reader :artist, "©ART"
      tag_reader :performer, "----:com.apple.iTunes:PERFORMER_NAME"

      def tags
        @tags ||= TagLib::MP4::File.open(path) { |file|
          Hash[file.tag.item_map.to_a.map { |k, i| [k, i.to_string_list.first] }]
        }
      end

      def album_artist
        tags["aART"] || artist
      end
    end
  end
end

PlexSymlinker::FileTypes::AudioFile.register_type :m4b, PlexSymlinker::FileTypes::Mp4
