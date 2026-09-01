# How to Read This Book

You don't have to read this cover to cover. The BOLTs are a specification, not a novel. Still, there is a path through them that matches how Lightning actually works, and that's the path this book follows.

Start with the overview and BOLT 00. That document is the table of contents, the glossary, and the design goals. If a later BOLT uses a word you don't recognize — `htlc_id`, `cltv_expiry`, `channel_ready` — BOLT 00 is where it was defined.

Then walk the stack. First you connect two nodes (transport, messages, features). Then you open a channel and learn the Bitcoin transactions that back it. Then you route a payment through other people's channels. Then you look at invoices and offers, which are how humans actually pay each other. Closures and on-chain recovery come after you understand a live channel. DNS bootstrap and Simple Taproot Channels are extras: useful, but they aren't the core loop.

Skip freely. If you only care about invoice format, jump to the payments chapter. If you're writing a gossip crawler, start at routing. Come back to the earlier chapters when a type or a message doesn't make sense.

One more thing: this book does not edit the BOLTs. Typos, ambiguities, and proposed changes belong in [lightning/bolts](https://github.com/lightning/bolts), not here. The git commit page near the front tells you which snapshot of the specs you're reading.
