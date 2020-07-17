require "plex/symlinker/file_types/audio_file"

module Plex
  module Symlinker
    module FileTypes

      # {
      #   "TDRC": "1968",
      #   "TIT2": "Seite B",
      #   "TKEY": "C",
      #   "TBPM": "120",
      #   "TPE1": "Winnetou",
      #   "TALB": "Winnetou 3 - 3. Folge",
      #   "TPE2": "alb-artist: Winnetou",
      #   "TCON": "Hörspiel",
      #   "APIC": "[image/jpeg]",
      #   "TRCK": "2/2",
      #   "TXXX": "[PERFORMER_NAME] PERFORMER_NAME a performer"
      # }
      class Mp3 < AudioFile
        tag_reader :album, "TALB"
        tag_reader :genre, "TCON"
        tag_reader :title, "TIT2"
        tag_reader :year, "TDRC"
        tag_reader :artist, "TPE1"
        tag_reader :track_number, "TRCK"

        def tags
          @tags ||= TagLib::MPEG::File.open(path) do |file|
            Hash[file.id3v2_tag.frame_list.map { |f| [f.frame_id, f.to_s] }]
          end
        end

        def album_artist
          tags["TPE2"] || artist
        end
      end
    end
  end
end

Plex::Symlinker::FileTypes::AudioFile.register_type :mp3, Plex::Symlinker::FileTypes::Mp3
