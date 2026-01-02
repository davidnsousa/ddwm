#!/bin/sh

calc () {
  while true; do
    read -e -r -p ": " expr || break
    history -s "$expr"
    expr="${expr//\$ans/$ans}"
    local in="$(echo " $expr" | sed -e 's/\[/(/g' -e 's/\]/)/g')"
    ans=$(gawk -M -v PREC=201 -M 'BEGIN {printf("%.4g",'"${in-0}"')}')
    printf "%*s\n" 20 "$ans"
  done
}

compresspdf() {
    infile="$1"
    quality="$2"

    case "$quality" in
        low)        preset="/screen" ;;
        balance)    preset="/ebook" ;;
        high)       preset="/printer" ;;
        veryhigh)   preset="/prepress" ;;
        *) echo "quality: low | balance | high | veryhigh"; return 1 ;;
    esac

    outfile="${infile%.*}-compressed.pdf"

    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 \
       -dPDFSETTINGS="$preset" \
       -dNOPAUSE -dQUIET -dBATCH \
       -sOutputFile="$outfile" "$infile"
}
