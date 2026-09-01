# Overview

Lightning is a network of payment channels sitting on top of Bitcoin. Two nodes lock coins into a shared output, then update a balance off-chain by exchanging signatures. When they are done, they broadcast the latest agreed state and walk away. Payments to people you don't have a channel with hop through other nodes, each hop wrapped in an onion.

The BOLTs — Basis of Lightning Technology — are the documents that make this interoperable. If your node speaks the BOLTs, it can open channels, route payments, and gossip with any other implementation. They are not a tutorial and they are not a whitepaper. They are the contract between implementations.

BOLT 00 is the front door. It explains the goals of the protocol, the keywords (`MUST`, `SHOULD`, `MAY`), and a glossary of terms you'll see everywhere else. Read it once for orientation, then keep it as a dictionary.

After that we'll stop going in numerical order. A node doesn't "do BOLT 01" in isolation. It first sets up an encrypted connection, then it talks, then it negotiates features. That's the next chapter.
