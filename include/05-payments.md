# Paying People

Lightning payments are still HTLCs under the hood, but humans don't paste onion packets into a wallet. They scan invoices, or they fetch offers.

BOLT 11 is the classic invoice. It's a bech32 string (`lnbc...` on mainnet) that encodes amount, payment hash, expiry, a description, a fallback on-chain address, and routing hints for unannounced channels. Almost every Lightning wallet you've used is speaking BOLT 11.

BOLT 12 is offers. Instead of a one-shot invoice, a receiver publishes a reusable offer. The payer requests an invoice over the Lightning network itself (onion messages), gets a fresh invoice back, and pays it. Offers can be static, they can request payer information, and they can be used for refunds. It's the more recent, more flexible cousin of BOLT 11.

If you're building a merchant flow, start with BOLT 11 — it's everywhere — then read BOLT 12 to see where the protocol is going.

**In this chapter**

- BOLT 11 — Invoice protocol
- BOLT 12 — Offers
