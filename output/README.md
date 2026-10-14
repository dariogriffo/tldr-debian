<div align="center">

# tldr (tlrc)

**Official tldr client written in Rust.**

![GitHub Release](https://img.shields.io/github/v/release/tldr-pages/tlrc?display_name=tag&color=%23a6a)
![GitHub License](https://img.shields.io/github/license/tldr-pages/tlrc)

</div>

## About

tldr pages are simplified, community-maintained help pages for command-line
tools: instead of a full manual, each page shows a handful of practical
examples of the most common uses. tlrc is the official client for the
tldr-pages project, written in Rust.

It keeps an offline cache of the pages that updates itself automatically,
supports platform-specific pages (linux, osx, windows, ...) and translations,
can search page descriptions (`--search`), can print a link to edit the shown
page on GitHub (`--edit`), and lets you tune colours and layout through a
small TOML config file.

**The command is `tldr`, the upstream project is called tlrc.**

Run `tldr <command>` to show a page, `tldr --update` to refresh the cache,
`tldr --config-path` to see where the config file lives and `tldr --help` for
the full command reference. The first run downloads the pages cache from the
internet.

**[Read the documentation](https://tldr.sh/tlrc)**
