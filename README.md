# PlexSymlinker

This gem allows creating a Plex-friendly folder structure with symlinks for your audio books.  
All you need are audio files with correct tagging, the gem takes care of making Plex understand them without you having to change the way you're organising your files.

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

## Usage

### Using the gem executable

#### 0. Make sure your files are properly tagged!

At least the `album` and `album artist` fields have to set accordingly.

But since you are planning to import those files into Plex which needs a lot more information,
it would make sense to fill out all details you can provide.

#### 1. Run the gem executable with source and target directory

```bash
plex_symlinker /path/to/audiobooks /path/to/symlinks
```

💡 If you ran PlexSymlinker before, you can just re-run it on the same directory again.
It will automatically sync the symlinks against the actual files and even delete no longer existing files.

#### 2. Create a Plex library pointing to the symlink directory

There might be multiple ways to achieve a good audiobook setup, but for me (with properly tagged files and embedded artwork), the following one worked great:

- [x] Prefer local metadata
- [x] Store track progress
- [x] Artist Bios
- Genres -> Embedded Tags
- Album Art -> Both Plex Music and Local Files
- Scanner -> Plex Music
- Agent -> Plex Music

### Using the Docker image

Please refer to [Docker Hub](https://hub.docker.com/r/sterexx/plex_symlinker) for instructions

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. 
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/stex/plex_symlinker. 
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/stex/plex_symlinker/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PlexSymlinker project's codebases, issue trackers, 
chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/stex/plex_symlinker/blob/master/CODE_OF_CONDUCT.md).
