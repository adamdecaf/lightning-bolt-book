# lightning-bolt-book

The [Lightning Network Specifications (BOLTs)](https://github.com/lightning/bolts), compiled into a readable book.

BOLTs are written for implementers and numbered as a catalog. This project leaves that text alone, wraps it with a pedagogical reading order, and builds an ebook from the result: connect, open a channel, route a payment, settle on-chain.

The book is compiled by Adam Shannon. The BOLTs are written by their original authors.

## Get the book

- [ePUB](https://github.com/adamdecaf/lightning-bolt-book/raw/master/lightning-bolt-book.epub)
- [PDF](https://github.com/adamdecaf/lightning-bolt-book/raw/master/lightning-bolt-book.pdf)

## What's inside

Chapters, not BOLT numbers:

1. Overview — BOLT 00, the glossary and design goals
2. Connecting nodes — transport (08), messaging (01), feature bits (09)
3. Opening and running channels — peer protocol (02), transactions (03)
4. Routing payments — onion routing (04), gossip (07)
5. Paying people — invoices (11), offers (12)
6. When channels close — on-chain (05)
7. Finding the network — DNS bootstrap (10)
8. Newer work — Simple Taproot Channels

## Contributing

Display, grouping, and wrapping-prose improvements are welcome.

Do **not** edit files under `bolts/`. That tree is a clone of [lightning/bolts](https://github.com/lightning/bolts). If a BOLT is wrong, unclear, or out of date, send the change upstream.

Editorial wrapping lives in `include/`. Reading order lives in `scripts/create.sh`.

## Development

You need [pandoc](https://github.com/jgm/pandoc/blob/main/INSTALL.md) and a LaTeX engine for PDF. On macOS:

```
brew install pandoc basictex
eval "$(/usr/libexec/path_helper)"
```

Clone this repo, then pull the BOLTs and build:

```
make setup    # clones or updates lightning/bolts into ./bolts
make epub
make pdf
```

`make setup` also writes the upstream git commit into `include/git.md` so the book records which snapshot it was built from.

## License

The code that generates this book is public domain (see [LICENSE](LICENSE)). BOLT content follows the license of [lightning/bolts](https://github.com/lightning/bolts) (CC BY 4.0).
