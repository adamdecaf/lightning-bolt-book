#!/bin/bash

inputs=(
    include/intro.md
    include/git.md

    bolts/00-introduction.md
    bolts/01-messaging.md
    bolts/02-peer-protocol.md
    bolts/03-transactions.md
    bolts/04-onion-routing.md
    bolts/05-onchain.md
    bolts/07-routing-gossip.md
    bolts/08-transport.md
    bolts/09-features.md
    bolts/10-dns-bootstrap.md
    bolts/11-payment-encoding.md
    bolts/12-offer-encoding.md

    include/conclusion.md
)

format=$1

chapters=()
for input in "${inputs[@]}"
do
    if [[ "$format" == "pdf" ]];
    then
        # The PDF engine needs page breaks inserted so each section is separated a bit more.
        chapters+=("include/pagebreak.md" "$input")
    else
        chapters+=("$input")
    fi
done

function create_epub() {
    # TODO(adam): Add epub flags
    # https://pandoc.org/MANUAL.html#option--epub-chapter-level
    pandoc --metadata-file=metadata.yml \
           --epub-metadata=./metadata-epub.yml \
           --highlight-style=monochrome \
           -s -o lightning-bolt-book.epub \
           "${chapters[@]}"
}

function create_pdf() {
    # TODO: needs "brew install basictex"
    # and   eval "$(/usr/libexec/path_helper)"

    pandoc --metadata-file=metadata.yml \
           --toc --toc-depth 2 \
           --pdf-engine=xelatex \
           --columns=72 --wrap=auto \
           --listings -H listings-settings.tex \
           -V fontsize="10pt" \
           -V mainfont="Palatino" \
           -V monofont="Monaco" \
           -V geometry:margin="0.75in" \
           -s -o lightning-bolt-book.pdf \
           "${chapters[@]}"

    # -V mainfontfallback="Apple Color Emoji"
    # -V monofontfallback="Apple Color Emoji"
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
        echo "Unknown format $format"
        exit 1
        ;;
esac
