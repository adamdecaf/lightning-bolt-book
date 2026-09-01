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

pdf_engine=xelatex
if command -v weasyprint >/dev/null 2>&1; then
    pdf_engine=weasyprint
fi

chapters=()
for input in "${inputs[@]}"
do
    if [[ "$format" == "pdf" && "$pdf_engine" == "xelatex" && "$input" == include/* && "$input" != include/pagebreak.md ]]; then
        chapters+=("include/pagebreak.md" "$input")
    else
        chapters+=("$input")
    fi
done

lua_filter=scripts/book.lua

function create_epub() {
    pandoc --metadata-file=metadata.yml \
           --epub-metadata=./metadata-epub.yml \
           --file-scope \
           --lua-filter="$lua_filter" \
           --split-level=2 \
           --toc --toc-depth=2 \
           --syntax-highlighting=monochrome \
           --resource-path=.:bolts \
           -s -o lightning-bolt-book.epub \
           "${chapters[@]}"
}

function create_pdf() {
    if [[ "$pdf_engine" == "weasyprint" ]]; then
        pandoc --metadata-file=metadata.yml \
               --file-scope \
               --lua-filter="$lua_filter" \
               --pdf-engine=weasyprint \
               --css=pdf.css \
               --toc --toc-depth=2 --metadata toc-title=Contents \
               --resource-path=.:bolts \
               -s -o lightning-bolt-book.pdf \
               "${chapters[@]}"
        return
    fi
    pandoc --metadata-file=metadata.yml \
           --file-scope \
           --lua-filter="$lua_filter" \
           --pdf-engine=xelatex \
           --wrap=none \
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

function create_html() {
    mkdir -p docs
    rm -rf docs/book docs/media media
    cp images/cover.png docs/cover.png
    pandoc --metadata-file=metadata.yml \
           --file-scope \
           --lua-filter="$lua_filter" \
           --to chunkedhtml \
           --template=templates/chunked.html \
           --split-level=2 \
           --chunk-template='%i.html' \
           --toc --toc-depth=2 --metadata toc-title=Contents \
           --css=../web.css \
           --syntax-highlighting=none \
           --extract-media=media \
           --resource-path=.:bolts \
           -o docs/book \
           "${chapters[@]}"
    python3 scripts/inject-web-toc.py
    python3 scripts/fix-web-media.py
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
    html)
        echo "Building HTML"
        create_html
        ;;
    *)
        echo "Unknown format ${format:-<none>}" >&2
        echo "usage: $0 epub|pdf|html" >&2
        exit 1
        ;;
esac
