# omnicow.fish

> Generate ALL THE COWS.

A plugin for Fish Shell that picks a random cow with `cowsay` or `cowthink`,
including random facial expressions and eyes.

## Installation

### System Requirements

- [fish](https://fishshell.com), version 3.5.1 or higher
  - Older versions of fish _may_ work, but will not be tested.
- `cowsay`, version 3.0 or higher
  - The version installed by your package manager should work, but the latest
    release from [this fork](https://github.com/cowsay-org/cowsay) is
    recommended.
- Perl 5
  - Perl is already a dependency for cowsay, but it's also explicitly mentioned
    here for clarity, since `perl` is also directly used in some functions.

Install with [Fisher](https://github.com/jorgebucaran/fisher) (recommended):

```fish
fisher install ProspectPyxis/omnicow.fish
```

Install with [oh my fish](https://github.com/oh-my-fish/oh-my-fish):

```fish
omf install ProspectPyxis/omnicow.fish
```

## Usage

Simply call `omnicow` like you would `cowsay` or `cowthink`. All flags that work
wish `cowsay` will also work with `omnicow`.

The base `omnicow` command accepts additional flags over `cowsay`:

- `--say`/`--think` - Forces `omnicow` to use only `cowsay` or `cowthink` rather
  than randomizing between the two, respectively. These flags are mutually
  exclusive.
- `--default-eyes`/`-E` - do not randomize the cow's eyes.
- `--max-height`/`--max-lines` - The maximum amount of lines a selected cowfile
  can have. This does _not_ include the speech bubble's height.
- `--max-width`/`--max-cols` - The maximum width a selected cowfile can have.
  This does _not_ include the speech bubble's width.
- `--no-exclude`/`-a` - By default, `omnicow` will respect the variable
  `omnicow_exclude_cowfiles` for cowfiles to not use (see
  [Settings/Omnicow database file](###Omnicow-database-file)). Set this flag to
  ignore the variable.

There is also a subcommand, `omnicow db`, that manages the omnicow database
file. For information on how to use this subcommand, run `omnicow db --help`.

## Settings

### Omnicow database file

`omnicow` will generate and read from a database for valid cows, and their
widths and heights (see [How it works](##How-it-works) below). By default, this
file is at `$XDG_DATA_HOME/cows/omnicowdb.csv` (`$XDG_DATA_HOME` defaults to
`~/.local/share` if not set). If you wish to store the omnicow database
somewhere else or with another filename, you can set the variables
`omnicow_db_path` for its location, and `omnicow_db_filename` for its filename.

```fish
# Just store the omnicow database in my home directory
set omnicow_db_path $HOME
# Make the database file hidden by adding a leading dot
set omnicow_db_filename '.omnicowdb.csv'
```

### Exclude certain cowfiles

If there are certain cowfiles you would like for omnicow to _not_ pick from, you
can set the `omnicow_exclude_cowfiles` variable.

This variable is empty by default.

```fish
# I don't want a three-eyed cow or a sheep!
set omnicow_exclude_cowfiles three-eyes sheep
```

## How it works

On the first run, `omnicow` will generate the file
`$XDG_DATA_HOME/cows/omnicowdb.csv` to use as a database for all cowfiles it can
find (`$XDG_DATA_HOME` defaults to `~/.local/share`); this is for `omnicow` to
be able to quickly read the widths and heights of cowfiles. All subsequent runs
of `omnicow` will read and write from this file. You can also manually set the
location and filename of the database file by setting the variables
`omnicow_db_path` and `omnicow_db_filename`, respectively (see
[Settings/Omnicow database file](###Omnicow-database-file)).

`omnicow` respects the `COWPATH` variable as to where it sources cowfiles from;
however, unlike the base `cowsay` command, this variable does not need to be
exported. If `COWPATH` is unset, `omnicow` will read from `/usr/share/cows`.

On subsequent runs, `omnicow` will check if any cowfiles have been added or
removed, and regenerate the database file if necessary. Note that it does _not_
check for changed files - if you edited a cowfile and wish to regenerate the
database, you must run `omnicow db generate --force` by yourself.

The database is always in comma-separated values format; however, instead of
parsing the file on your own, it's likely easier to use the `omnicow db get`
subcommand to get values from the file.

## Roadmap

The following features are planned for the future:

- [ ] More robust randomized faces - random tongue, add a tongue when using "XX"
      or "\*\*" eyes, etc.
- [ ] More configuration on possible eye types
- [ ] A whitelist of allowed cowfiles.

## Contributing

Any pull requests, issues, or feature requests are welcome!

## License

This project is licensed under the [MIT License](LICENSE).
