#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if [ -d 'bolts' ];
then
    echo "Updating lightning/bolts"
    git -C bolts pull origin master
else
    echo "Pulling lightning/bolts"
    git clone https://github.com/lightning/bolts.git
fi

{
    echo "# Source snapshot"
    echo ""
    echo "This book was built from the following commit of [lightning/bolts](https://github.com/lightning/bolts). If something here disagrees with upstream, upstream wins."
    echo ""
    echo '```'
    git -C bolts log -n1
    echo '```'
} > include/git.md
