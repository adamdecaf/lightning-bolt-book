# Introduction

Welcome to the Lightning Book of BOLTs. This is a reading companion to the [Lightning Network Specifications (BOLTs)](https://github.com/lightning/bolts) — the documents that Lightning implementations actually implement.

I didn't write the BOLTs. Credit belongs to the original authors and the many contributors who have argued, patched, and shipped this protocol over the years. My job here is to put those specs in an order you can actually read, and to add a little context at the start of each chapter so you know why you're looking at a given BOLT.

The official repository numbers the BOLTs 00, 01, 02, and so on. That's a fine catalog. It's a rough way to learn the protocol. This book groups them the way a node actually uses them: connect, open a channel, route a payment, settle on-chain.

Each chapter starts with a short introduction, then the BOLT text itself, unchanged. If something in a spec looks dense, that's because it is — these documents are written for implementers. The wrapping text is here so you don't have to guess which document to open next.

Thanks for picking this up. I hope it makes Lightning a little less intimidating, and that it sends you back to the real BOLTs (and to contributing upstream) when you're ready.
