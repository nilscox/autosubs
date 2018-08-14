# autosubs

This is a tool I use to automatically download movie and tvshow subtitles.

With it, you can forget all about downloading subtitles for your favourite
movies, autosubs will take care of that for you.

As I am using `autosubs` just for my needs, I didn't do much about options and
stuff. But please feel free to open an issue / submit a PR, I'm really open to
any suggestions!

## Running autosubs

Build the docker image:

```sh
42sh$ docker build -t autosubs .
```

Run the container:

```sh
docker run -dt \
  --name autosubs \
  -e SUBS_LANG="$SUBS_LANG" \
  -v "${SUBS_WATCHDIR}:/media" \
  -u "$(id -u):$(id -g)" \
  autosubs
```

Don't forget to export the environment variables!

`$SUBS_LANG`: language as IETF code, e.g. en, pt-BR.
`$SUBS_WATCHDIR`: path in the host machine to the watched files.

When a file is created in the `$SUBS_WATCHDIR` directory (or a sub-directory),
and its name ends with `.avi`, `.mp4` or `.mkv`, the container launches
[subliminal](https://github.com/Diaoul/subliminal), a brilliant tool for
searching and downloading / renaming subtitles.

> Note: the user launching the docker image must have read / write access to
> the `$SUBS_WATCHDIR` directory, otherwise you must set correct uid / gid
> values when starting the container.

## Wat is works how?

The docker container will mount a shared volume at `/media`, refering to the
`$SUBS_WATCHDIR` directory in the host. It will then run
[`inotifywait`](https://linux.die.net/man/1/inotifywait), watching for files
creation. When a file's name matches `\.(avi|mp4|mkv)$`, subliminal downloads
the appropriate subtitles.

TODO:

- use --cache instead of creating `/.cache`
- handle other subliminal options
- download subtitles for multiple languages
- ... your ideas?

## License

[MIT](./LICENSE)
