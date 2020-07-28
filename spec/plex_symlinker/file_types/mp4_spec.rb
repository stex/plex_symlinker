RSpec.describe PlexSymlinker::FileTypes::Mp4 do
  let(:file) { resource_file("example.m4b") }
  subject { described_class.new(file.to_s) }

  its(:sort_album_artist) { is_expected.to eql "m4b-book-sort-album-artist" }
  its(:sort_artist) { is_expected.to eql "m4b-book-sort-artist" }
  its(:sort_album) { is_expected.to eql "m4b-book-sort-album" }
  its(:album) { is_expected.to eql "m4b-book-album" }

  its(:genre) { is_expected.to eql "m4b-book-genre" }
  its(:title) { is_expected.to eql "m4b-book-title" }
  its(:year) { is_expected.to eql "2001" }
  its(:artist) { is_expected.to eql "m4b-book-artist" }
  its(:performer) { is_expected.to eql "m4b-book-performer" }
end
