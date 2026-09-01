# Source snapshot

This book was built from the following commit of [lightning/bolts](https://github.com/lightning/bolts). If something here disagrees with upstream, upstream wins.

```
commit 152897261850d93c4f4597f39cf22d7d22d6ede6
Author: Joost Jager <joost.jager@gmail.com>
Date:   Wed Aug 26 08:50:01 2026 +0200

    Limit attributable return fields to 32 KiB (#1349)
    
    Cap failure return packets and fulfillment payloads at 32 KiB to
    reserve room for attribution data and future extensions.
    
    Truncate oversized legacy failure packets when forwarding, while
    treating oversized fulfillment payloads as protocol violations.
```
