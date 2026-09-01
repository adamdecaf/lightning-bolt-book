#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

inputs=(
    include/intro.md
    include/how-to-read.md
    include/git.md

    include/01-overview.md
    bolts/00-introduction.md

    include/02-connecting.md
    bolts/08-transport.md
    bolts/01-messaging.md
    bolts/09-features.md

    include/03-channels.md
    bolts/02-peer-protocol.md
    bolts/03-transactions.md

    include/04-routing.md
    bolts/04-onion-routing.md
    bolts/07-routing-gossip.md

    include/05-payments.md
    bolts/11-payment-encoding.md
    bolts/12-offer-encoding.md

    include/06-onchain.md
    bolts/05-onchain.md

    include/07-bootstrap.md
    bolts/10-dns-bootstrap.md

    include/08-taproot.md
    bolts/bolt-simple-taproot.md

    include/conclusion.md
)

format=${1:-}

missing=0
for input in "${inputs[@]}"
do
    if [[ ! -f "$input" ]]; then
        echo "error: missing $input" >&2
        missing=1
    fi
done
if [[ "$missing" -ne 0 ]]; then
    echo "Run 'make setup' first, or update the chapter list." >&2
    exit 1
fi

chapters=()
for input in "${inputs[@]}"
do
    if [[ "$format" == "pdf" && "$input" == include/* && "$input" != include/pagebreak.md ]]; then
        chapters+=("include/pagebreak.md" "$input")
    else
        chapters+=("$input")
    fi
done

function create_epub() {
    pandoc --metadata-file=metadata.yml \
           --epub-metadata=./metadata-epub.yml \
           --syntax-highlighting=monochrome \
           --resource-path=.:bolts \
           -s -o lightning-bolt-book.epub \
           "${chapters[@]}"
}

function create_pdf() {
    pandoc --metadata-file=metadata.yml \
           --toc --toc-depth 2 \
           --pdf-engine=xelatex \
           --columns=72 --wrap=auto \
           -f markdown-strikeout-footnotes \
           --syntax-highlighting=none \
           --resource-path=.:bolts \
           -V fontsize="10pt" \
           -V mainfont="Palatino" \
           -V monofont="Monaco" \
           -V mainfontfallback="Hiragino Mincho ProN,Apple Color Emoji" \
           -V monofontfallback="Menlo,Hiragino Sans,Apple Color Emoji" \
           -V geometry:margin="0.75in" \
           -s -o lightning-bolt-book.pdf \
           "${chapters[@]}"
}

case "$format" in
    epub)
        echo "Building ePUB"
        create_epub
        ;;
    pdf)
        echo "Building PDF"
        create_pdf
        ;;
    *)
        echo "Unknown format ${format:-<none>}" >&2
        echo "usage: $0 epub|pdf" >&2
        exit 1
        ;;
esac
