# PlexSymlinker

This gem allows creating a Plex-friendly folder structure with symlinks for your audio books.  
All you need are audio files with correct tagging, the gem takes care of making Plex understand them without you having to change the way you're organising your files.

⬇️ If you're on Docker Hub, just scroll down to "Usage".

**The Problem**

Most of my audio files are in apple's `m4b` format, leaving me with one file per book most of the times:

    📁 audiobooks
     ∟ 📁 author name
        ∟ book1.m4b
        ∟ book2.m4b

The problem with this structure is that Plex' music agent doesn't quite understand it.  
Even though the files are properly tagged with author, album, etc., Plex tends to create a giant
album out of all the files inside - often with the first audio book as album name.

What the Plex music agent expects is a structure like this:

    📁 audiobooks
     ∟ 📁 author name
        ∟ 📁 Book 1
           ∟ book1.m4b
        ∟ 📁 Book 2
           ∟ book2.m4b

This would mean that I'd have to introduce single-file-directories into my structure which didn't really make
sense for me - especially as I have a lot of "Hörspiele" (mostly german format of short audio books with multiple
actors + music).

**This gem's solution**

`plex_symlinker` creates symlinks pointing to your actual audio files in exactly the structure Plex' music agent
expects to find. It uses the embedded tags in your files to build it, so even one big directory with
all your audio files in it would work as expected.

Just point plex to the symlink directory instead of your actual files and you're good to go.

## Installation

There are 2 ways to install/use this gem:

**Option 1: Install the gem on your local machine and run it directly**

```bash
gem install plex_symlinker
```

As this gem makes use of `taglib-ruby`, you have to make sure that the necessary packages are installed on your machine.  
Please refer to [robinst/taglib-ruby](https://github.com/robinst/taglib-ruby#installation) for more information.

**Option 2: Use the docker image**

A [docker image](https://hub.docker.com/r/sterexx/plex_symlinker) is available which includes
all necessary dependencies and can be used out-of-the-box by mounting the necessary directories.  
See below for examples.

## Usage

### Using the gem executable

### Using the Docker image

Since the whole purpose of PlexSymlinker is to read a directory full of audio files and fill another directory
with symlinks, we have to make sure the docker container has access to both of them.

When using the docker image, the audio files directory is expected to be mounted as `/app/source` and the directory
the symlinks should be placed in as `/app/target`.

💡 You also have to pass in the `SYMLINK_TARGET_DIR` environment variable. Since the gem only sees `/app/source` inside
the docker container, it would point all symlinks there instead of the actual directory on your host machine. Just set it to
the same directory that you mounted as `/app/source`.

#### 1. Create the directory the symlinks should be placed in (if it doesn't exist yet)

It's important that the directory exists (owned by your current user) before you mount it.

```bash
mkdir -p /path/to/symlink/dir
```

#### 2. Run the docker image**

**MacOS**

```bash
docker run -it --rm -v /path/to/audiobooks:/app/source -v /path/to/symlink/dir:/app/target --env SYMLINK_TARGET_DIR=/path/to/audiobooks sterexx/plex_symlinker
```

**Linux**

💡 Under Linux, you have to make sure to set your current user/group id with `--user "$(id -u):$(id -g)"` - otherwise, all the 
generated symlinks/directories will be owned by the root user.
Docker for mac/windows takes care of that for you automatically.

```bash
docker run -it --user "$(id -u):$(id -g)" --rm -v /path/to/audiobooks:/app/source -v /path/to/symlink/dir:/app/target --env SYMLINK_TARGET_DIR=/path/to/audiobooks sterexx/plex_symlinker
```

#### 3. Add a plex library for the symlink directory

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/stex/plex_symlinker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/plex-symlinker/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PlexSymlinker project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/stex/plex-symlinker/blob/master/CODE_OF_CONDUCT.md).
