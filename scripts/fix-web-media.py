#!/usr/bin/env python3
"""Put extracted images next to the chunked HTML and copy leftover local assets."""

from pathlib import Path
import re
import shutil

root = Path(__file__).resolve().parent.parent
book = root / "docs" / "book"
extracted = root / "media"

if extracted.is_dir():
    dest = book / "media"
    if dest.exists():
        shutil.rmtree(dest)
    shutil.move(str(extracted), str(dest))

search_roots = [root / "bolts", root / "nuts", root / "bips", root]

src_re = re.compile(r'(src|href)="([^"]+)"')

for html in book.glob("*.html"):
    text = html.read_text()
    text = text.replace("src=\"docs/media/", "src=\"media/")
    text = text.replace("href=\"docs/media/", "href=\"media/")

    def copy_local(match):
        attr, url = match.group(1), match.group(2)
        if url.startswith(("http://", "https://", "mailto:", "#", "media/")):
            return match.group(0)
        rel = Path(url)
        dest = book / rel
        if dest.exists():
            return match.group(0)
        for base in search_roots:
            src = base / rel
            if src.is_file():
                dest.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(src, dest)
                break
        return match.group(0)

    html.write_text(src_re.sub(copy_local, text))
