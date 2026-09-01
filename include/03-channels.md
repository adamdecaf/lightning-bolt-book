# Opening and Running Channels

A Lightning channel is a Bitcoin output that two people share, plus a set of rules for updating who owns how much without going back to the chain every time.

BOLT 02 is the peer protocol for that. It covers the whole channel lifecycle: opening (`open_channel` / `accept_channel` / `funding_created` / `funding_signed`), going live (`channel_ready`), sending payments with HTLCs (`update_add_htlc` and friends), committing a new state (`commitment_signed` / `revoke_and_ack`), and cooperative close. If you're implementing a node, you'll live in this document.

BOLT 03 is the Bitcoin underneath. It specifies the funding transaction, the commitment transactions, HTLC-timeout and HTLC-success transactions, and the scripts and signature formats that make the penalty model work. BOLT 02 is the conversation; BOLT 03 is the money.

You can read BOLT 02 first for the flow, then BOLT 03 when you need to know exactly what gets signed. Or keep them side by side. They were meant to be a pair.
