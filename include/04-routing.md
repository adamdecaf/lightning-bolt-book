# Routing Payments

You don't open a channel with everyone you pay. Most Lightning payments bounce through other people's channels, and the sender is the one who picks the path.

BOLT 04 is onion routing. The sender builds a Sphinx onion: each hop can only decrypt its own layer, which tells it the next node, the amount, and the CLTV expiry. Inner hops don't learn the source, the destination, or the full route. Failures come back along the same onion, encrypted so that only the sender can make sense of them.

BOLT 07 is gossip — how you learn the graph that onions are built on. Nodes announce themselves and their channels, sign those announcements, and flood them through the network. Channel updates carry fees and expiry deltas. Without gossip, onion routing has nowhere to go; without onions, gossip is just a map.

Together these two BOLTs are how a payment finds its way. Invoices, in the next chapter, are how you know who to pay and what hash to use.

**In this chapter**

- BOLT 04 — Onion routing
- BOLT 07 — P2P node and channel discovery (gossip)
