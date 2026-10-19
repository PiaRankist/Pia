"""Schaltet den Halloween-Look in sections/header-group.json ein (oder mit --undo wieder aus).

Ändert nur die Section halloween_effekte (drei Haken) und hängt halloween_komplett an.
Alles andere in der Datei bleibt, wie es ist.
"""
import json
import re
import sys

EFFEKTE_ON = {"font": True, "all_headings": True, "pdp_box": True}


def main(path, undo=False):
    raw = open(path, encoding="utf-8").read()
    match = re.match(r"\s*(/\*.*?\*/)?\s*", raw, re.S)
    header = match.group(1) or ""
    data = json.loads(raw[match.end():])
    sections, order = data["sections"], data["order"]

    effekte = sections.get("halloween_effekte")
    if effekte is None:
        sys.exit("Fehler: Section halloween_effekte fehlt in header-group.json, nichts geändert.")

    if undo:
        for key in EFFEKTE_ON:
            effekte["settings"][key] = False
        sections.pop("halloween_komplett", None)
        if "halloween_komplett" in order:
            order.remove("halloween_komplett")
    else:
        effekte["settings"].update(EFFEKTE_ON)
        sections["halloween_komplett"] = {"type": "halloween-komplett", "settings": {}}
        if "halloween_komplett" not in order:
            order.append("halloween_komplett")

    body = json.dumps(data, ensure_ascii=False, indent=2)
    with open(path, "w", encoding="utf-8") as f:
        f.write((header + "\n" if header else "") + body + "\n")
    print("header-group.json:", "Halloween aus" if undo else "Halloween an", "| order:", order)


if __name__ == "__main__":
    main(sys.argv[1], undo="--undo" in sys.argv)
