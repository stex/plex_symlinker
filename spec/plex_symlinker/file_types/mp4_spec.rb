RSpec.describe PlexSymlinker::FileTypes::Mp4 do
  let(:file) { resource_file("example.m4b") }
  subject { described_class.new(file.to_s) }

  its(:sort_album_artist) { is_expected.to eql "book-sort-album-artist" }
  its(:sort_artist) { is_expected.to eql "book-sort-artist" }
  its(:sort_album) { is_expected.to eql "book-sort-album" }
  its(:album) { is_expected.to eql "book-album" }

  its(:genre) { is_expected.to eql "book-genre" }
  its(:title) { is_expected.to eql "book-title" }
  its(:year) { is_expected.to eql "2001" }
  its(:artist) { is_expected.to eql "book-artist" }
  its(:performer) { is_expected.to eql "book-performer" }
end
