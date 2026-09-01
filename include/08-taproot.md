# Newer Work

Lightning's original channels use a 2-of-2 `OP_CHECKMULTISIG` funding output. It works. It also looks like a Lightning channel on-chain, and it predates Taproot.

Simple Taproot Channels move funding into a Taproot output. Cooperative closes look like a single-key spend. The commitment format changes, musig2 shows up, and a few BOLT 02 / BOLT 03 messages grow extra fields. The rest of the protocol — invoices, onions, gossip — stays the same.

This document is newer than the numbered BOLTs, and implementations are still catching up. Read it after you're comfortable with BOLT 02 and BOLT 03, because it's a variation on those two, not a replacement for the rest of the book.

Treat it as a look at where channel construction is heading, not as required reading for a first implementation.

**In this chapter**

- Simple Taproot Channels
