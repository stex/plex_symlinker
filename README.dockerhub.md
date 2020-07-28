# PlexSymlinker

This gem allows creating a Plex-friendly folder structure with symlinks for your audio books.
All you need are audio files with correct tagging, the gem takes care of making Plex understand them without you having to change the way you're organising your files.

**The Problem**

Most of my audio files are in apple's m4b format, leaving me with one file per book most of the times:

    📁 audiobooks
     ∟ 📁 author name
        ∟ book1.m4b
        ∟ book2.m4b

The problem with this structure is that Plex' music agent doesn't quite understand it.
Even though the files are properly tagged with author, album, etc., Plex tends to create a giant album out of all the files inside - often with the first audio book as album name.

What the Plex music agent expects is a structure like this:

    📁 audiobooks
     ∟ 📁 author name
        ∟ 📁 Book 1
           ∟ book1.m4b
        ∟ 📁 Book 2
           ∟ book2.m4b

This would mean that I'd have to introduce single-file-directories into my structure which didn't really make sense for me - especially as I have a lot of "Hörspiele" (mostly german format of short audio books with multiple actors + music).

**This gem's solution**

PlexSymlinker creates symlinks pointing to your actual audio files in exactly the 
structure Plex' music agent expects to find. It uses the embedded tags in your files to build it, 
so even one big directory with all your audio files in it would work as expected.

Just point plex to the symlink directory instead of your actual files and you're good to go.

## Usage

Since the whole purpose of PlexSymlinker is to read a directory full of audio files and 
fill another directory with symlinks, we have to make sure the docker container has access to both of them.

When using the docker image, the audio files directory is expected to be mounted
as `/app/source` and the directory the symlinks should be placed in as `/app/target`.

💡 You also have to pass in the `SYMLINK_TARGET_DIR` environment variable. 
Since the gem only sees `/app/source` inside the docker container, 
it would point all symlinks there instead of the actual directory on your host machine. 
Just set it to the same directory that you mounted as `/app/source`.

### 0. Make sure your files are properly tagged!

At least the album and album artist fields have to set accordingly.

But since you are planning to import those files into Plex which needs a lot more information, 
it would make sense to fill out all details you can provide.

### 1. Create the directory the symlinks should be placed in (if it doesn't exist yet)

It's important that the directory exists (owned by your current user) before you mount it.

    mkdir -p /path/to/symlink/dir

If you ran PlexSymlinker before, you can just re-run it on the same directory again. 
It will automatically sync the symlinks against the actual files.

### 2. Run the docker image

#### MacOS

    docker run -it --rm -v /path/to/audiobooks:/app/source:ro -v /path/to/symlink/dir:/app/target --env SYMLINK_TARGET_DIR=/path/to/audiobooks sterexx/plex_symlinker

#### Linux

💡 Under Linux, you have to make sure to set your current user/group id 
with `--user "$(id -u):$(id -g)"` - otherwise, all the generated symlinks/directories 
will be owned by the root user. Docker for mac/windows takes care of that for you automatically.

    docker run -it --user "$(id -u):$(id -g)" --rm -v /path/to/audiobooks:/app/source:ro -v /path/to/symlink/dir:/app/target --env SYMLINK_TARGET_DIR=/path/to/audiobooks sterexx/plex_symlinker

### 3. Create a Plex library pointing to the symlink directory


There might be multiple ways to achieve a good audiobook setup, but for me (with properly tagged files and embedded artwork), the following one worked great:

✅ Prefer local metadata  
✅ Store track progress  
✅ Artist Bios  
- Genres -> Embedded Tags
- Album Art -> Both Plex Music and Local Files
- Scanner -> Plex Music
- Agent -> Plex Music
