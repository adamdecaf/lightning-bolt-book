# Finding the Network

Gossip tells you about nodes you've already heard of. It doesn't tell you how to find the first one.

BOLT 10 is DNS bootstrap. Lightning nodes can publish SRV and node records under a seed domain so a new peer can resolve a handful of entry points, connect, and start receiving gossip. It's a small document, and it's optional in spirit — you can always paste a peer address by hand — but it's how a node joins the network without a phone book.

If you're running a seed, this BOLT is the contract you have with the rest of the network. If you're writing a client, it's the one-time lookup before BOLT 07 takes over.

**In this chapter**

- BOLT 10 — DNS bootstrap
