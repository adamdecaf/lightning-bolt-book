# When Channels Close

Channels are great until they aren't. A peer disappears, a revocation secret gets broadcast, an HTLC is about to expire. Then you're on-chain, and the chain doesn't care about your encrypted transport.

BOLT 05 is the playbook for that. It tells an implementation how to watch for commitment transactions, when to broadcast a penalty, how to resolve HTLCs on-chain, and how to sweep outputs so you actually get your coins back. It's less about messages and more about timeouts, scripts, and not racing yourself.

Read this after you understand commitment transactions in BOLT 03. The on-chain rules only make sense once you know what those transactions look like.

Most of the time a cooperative close from BOLT 02 is enough. BOLT 05 is for the rest of the time — which is exactly when you need a spec.

**In this chapter**

- BOLT 05 — On-chain closing and recovery
