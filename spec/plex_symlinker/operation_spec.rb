RSpec.describe PlexSymlinker::Operation do
  let(:tmp_source_dir) { spec_root.join("tmp", "source") }
  let(:tmp_symlinks_dir) { spec_root.join("tmp", "symlinks") }

  before(:each) do
    FileUtils.rm_rf(spec_root.join("tmp"))
    FileUtils.mkdir_p([tmp_source_dir, tmp_symlinks_dir])
    FileUtils.cp(resource_files, tmp_source_dir)

    PlexSymlinker.output = File.new("/dev/null", "w")
  end

  after(:all) do
    FileUtils.rm_rf(spec_root.join("tmp"))
  end

  subject { described_class.new(files_base_dir.to_s, symlinks_base_dir.to_s, symlink_target_dir: symlink_target_dir.to_s) }

  #----------------------------------------------------------------
  #                       #create_symlinks
  #----------------------------------------------------------------

  describe "#create_symlinks" do
    shared_examples "symlink creation" do
      let(:expected_symlinks) {
        files_base_dir.children.map { |file|
          af = PlexSymlinker::FileTypes::AudioFile.from_path(file.to_s)
          ["", af.album_artist, af.album, af.symlink_file_name].join("/")
        }
      }

      it "generates the expected folder structure" do
        expect { subject.create_symlinks }
          .to change { Dir[symlinks_base_dir.join("**", "*.*")].map { |p| p.gsub(symlinks_base_dir.to_s, "") } }
          .from([])
          .to match_array(expected_symlinks)
      end

      it "points the generated symlinks to the actual files" do
        subject.create_symlinks
        expect(Dir[symlinks_base_dir.join("**", "*.*")].map(&File.method(:readlink)))
          .to match_array(expected_symlink_targets)
      end
    end

    context "with a custom symlink target dir" do
      include_examples "symlink creation" do
        # Would be /app/source in the base docker setup
        let(:files_base_dir) { tmp_source_dir }

        # Would be /app/target in the base docker setup
        let(:symlinks_base_dir) { tmp_symlinks_dir }

        # Would be the actual files directory on the host machine in the base docker setup
        # As the directory wouldn't exist within the docker container either, we use a
        # a non-existent path here as well. It's only important that the existing symlinks will
        # point to this directory instead of +files_base_dir+
        let(:symlink_target_dir) { Pathname.new("/tmp/audio_files") }

        let(:expected_symlink_targets) {
          files_base_dir.children(false).map { |f| symlink_target_dir.join(f.to_s).to_s }
        }
      end
    end

    context "with no custom symlink target dir" do
      include_examples "symlink creation" do
        let(:files_base_dir) { tmp_source_dir }
        let(:symlinks_base_dir) { tmp_symlinks_dir }
        let(:symlink_target_dir) { nil }

        let(:expected_symlink_targets) {
          files_base_dir.children.map(&:to_s)
        }
      end
    end
  end

  #----------------------------------------------------------------
  #                           #cleanup
  #----------------------------------------------------------------

  describe "#cleanup" do
    shared_examples "cleanup" do
      let!(:valid_existing_symlink) { symlinks_base_dir.join("existing.mp3").tap { |path| File.symlink(existing_file, path) } }
      let!(:invalid_existing_symlink) { symlinks_base_dir.join("deleted.mp3").tap { |path| File.symlink(deleted_file, path) } }

      it "removes invalid symlinks" do
        expect { subject.cleanup }
          .to change { symlinks_base_dir.children(false).map(&:to_s) }
          .from(array_including(["existing.mp3", "deleted.mp3"]))
          .to(["existing.mp3"])
      end
    end

    context "with a custom symlink target dir" do
      include_examples "cleanup" do
        # Would be /app/source in the base docker setup
        let(:files_base_dir) { tmp_source_dir }

        # Would be /app/target in the base docker setup
        let(:symlinks_base_dir) { tmp_symlinks_dir }

        # Would be the actual files directory on the host machine in the base docker setup
        # As the directory wouldn't exist within the docker container either, we use a
        # a non-existent path here as well. It's only important that the existing symlinks will
        # point to this directory instead of +files_base_dir+
        let(:symlink_target_dir) { Pathname.new("/tmp/audio_files") }

        let(:existing_file) { symlink_target_dir.join("example.mp3") }
        let(:deleted_file) { symlink_target_dir.join("deleted.mp3") }
      end
    end

    context "with no custom symlink target dir" do
      include_examples "cleanup" do
        let(:files_base_dir) { tmp_source_dir }
        let(:symlinks_base_dir) { tmp_symlinks_dir }
        let(:symlink_target_dir) { nil }

        let(:existing_file) { files_base_dir.join("example.mp3") }
        let(:deleted_file) { files_base_dir.join("deleted.mp3") }
      end
    end
  end
end
