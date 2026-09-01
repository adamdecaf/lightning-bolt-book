# Connecting Nodes

Before two Lightning nodes can open a channel, they have to talk. That means a TCP connection, an encrypted handshake, and a shared idea of which messages exist.

BOLT 08 is the transport. Lightning uses a Noise protocol handshake (`Noise_XK`) so that by the time the first application message is sent, both sides have authenticated keys and an encrypted session. If you've ever wondered why Lightning node IDs are public keys, this is why: the transport identity *is* the node identity.

BOLT 01 is the messaging layer that rides on that session. It defines the binary framing, the type system, and the messages every peer needs — `init`, `error`, `ping` / `pong`. Everything later in the book is a BOLT 01 message with a more interesting type.

BOLT 09 is the feature bits. Lightning is still changing, so peers advertise what they support during `init` and inside invoices, node announcements, and other gossip. If a message in a later BOLT is optional, BOLT 09 is where that option got a number.

Read these three in order. Transport, then messages, then the flags that say which messages you're allowed to send.

**In this chapter**

- BOLT 08 — Encrypted and authenticated transport
- BOLT 01 — Base messaging
- BOLT 09 — Feature flags
