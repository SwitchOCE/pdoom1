#!/usr/bin/env python3
"""Build fork/design/hifi3/index.html from page.src.html.

Fills three slots:
  {{SPEC}}  spec.md converted to HTML (a small converter, no library)
  {{SOUND}} the dateline sound block cut from H/concept.html, between the
            markers SOUND_START and SOUND_END (see SOUND_MARKERS)
  {{DEMO}}  demo.js beside this script (the page's dateline demo)
Run: python3 fork/design/hifi3/build_page.py
"""
import html
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
SOUND_MARKERS = ("SOUND_START", "SOUND_END")


def inline(text):
    t = html.escape(text, quote=False)
    codes = []

    def keep(m):
        codes.append("<code>" + m.group(1) + "</code>")
        return "\x00%d\x00" % (len(codes) - 1)

    t = re.sub(r"`([^`]+)`", keep, t)
    t = re.sub(r"\[([^\]]+)\]\((https?://[^)\s]+)\)", r'<a href="\2">\1</a>', t)
    t = re.sub(r"\[([^\]]+)\]\(([^)\s]+)\)", r"\1 (<code>\2</code>)", t)
    t = re.sub(r"\*\*([^*]+)\*\*", r"<b>\1</b>", t)
    t = re.sub(r"(?<![\w*])\*([^*\s][^*]*)\*(?![\w*])", r"<i>\1</i>", t)
    t = re.sub(r"\x00(\d+)\x00", lambda m: codes[int(m.group(1))], t)
    return t


def md_to_html(md):
    lines = md.replace("\r\n", "\n").split("\n")
    out = []
    i = 0
    para = []
    lists = []  # stack of (indent, tag)

    def flush_para():
        if para:
            out.append("<p>" + inline(" ".join(s.strip() for s in para)) + "</p>")
            para.clear()

    def close_lists(to_indent=-1):
        while lists and lists[-1][0] > to_indent:
            out.append("</li></%s>" % lists.pop()[1])

    while i < len(lines):
        line = lines[i]
        s = line.strip()
        if s.startswith("```"):
            flush_para(); close_lists()
            j = i + 1
            buf = []
            while j < len(lines) and not lines[j].strip().startswith("```"):
                buf.append(lines[j]); j += 1
            out.append("<pre><code>" + html.escape("\n".join(buf)) + "</code></pre>")
            i = j + 1
            continue
        if not s:
            flush_para()
            # a blank line ends a list only if the next line is not a list item
            nxt = next((l for l in lines[i + 1:] if l.strip()), "")
            if lists and not re.match(r"\s*([-*]|\d+[.)])\s", nxt) and not (nxt.startswith("  ") and lists):
                close_lists()
            i += 1
            continue
        m = re.match(r"(#{1,6})\s+(.*)", s)
        if m and not line.startswith(" "):
            flush_para(); close_lists()
            level = len(m.group(1))
            level = 2 if level == 1 else min(level, 4)  # page h1 is the page title
            out.append("<h%d>%s</h%d>" % (level, inline(m.group(2)), level))
            i += 1
            continue
        if s.startswith("|") and i + 1 < len(lines) and re.match(r"\s*\|?\s*:?-{3,}", lines[i + 1]):
            flush_para(); close_lists()
            def cells(r):
                r = r.strip().strip("|")
                return [c.strip() for c in r.split("|")]
            head = cells(s)
            rows = []
            j = i + 2
            while j < len(lines) and lines[j].strip().startswith("|"):
                rows.append(cells(lines[j])); j += 1
            t = ['<div class="tbl-wrap"><table><thead><tr>']
            t += ["<th>%s</th>" % inline(c) for c in head]
            t.append("</tr></thead><tbody>")
            for r in rows:
                t.append("<tr>" + "".join("<td>%s</td>" % inline(c) for c in r) + "</tr>")
            t.append("</tbody></table></div>")
            out.append("".join(t))
            i = j
            continue
        m = re.match(r"(\s*)([-*]|\d+[.)])\s+(.*)", line)
        if m:
            flush_para()
            ind = len(m.group(1).expandtabs(4))
            tag = "ol" if m.group(2)[0].isdigit() else "ul"
            if lists and ind < lists[-1][0]:
                close_lists(ind)
            if not lists or ind > lists[-1][0]:
                start = ""
                if tag == "ol" and m.group(2)[:-1] != "1":
                    start = ' start="%s"' % m.group(2)[:-1]
                out.append("<%s%s><li>" % (tag, start))
                lists.append((ind, tag))
            else:
                out.append("</li><li>")
            # join the item's continuation lines first, so bold or code
            # wrapped across lines is formatted as one run
            text = [m.group(3)]
            j = i + 1
            while (j < len(lines) and lines[j].strip() and lines[j].startswith(" ")
                   and not re.match(r"\s*([-*]|\d+[.)])\s", lines[j])
                   and not lines[j].strip().startswith("```")):
                text.append(lines[j].strip()); j += 1
            out.append(inline(" ".join(text)))
            i = j
            continue
        if lists and line.startswith(" "):
            out.append(" " + inline(s))
            i += 1
            continue
        if s.startswith(">"):
            flush_para(); close_lists()
            buf = []
            while i < len(lines) and lines[i].strip().startswith(">"):
                buf.append(lines[i].strip()[1:].strip()); i += 1
            out.append('<div class="callout">' + inline(" ".join(buf)) + "</div>")
            continue
        close_lists()
        para.append(line)
        i += 1
    flush_para(); close_lists()
    return "\n".join(out)


def sound_block():
    src = (HERE / "H" / "concept.html").read_text(encoding="utf-8")
    a, b = SOUND_MARKERS
    m = re.search(r"[^\n]*%s[^\n]*\n(.*?)\n[^\n]*%s" % (a, b), src, re.S)
    if not m:
        sys.exit("sound markers %s/%s not found in H/concept.html" % SOUND_MARKERS)
    return m.group(1)


def main():
    page = (HERE / "page.src.html").read_text(encoding="utf-8")
    spec = HERE / "spec.md"
    spec_md = spec.read_text(encoding="utf-8") if spec.exists() else ""
    spec_md = re.sub(r"\A# [^\n]*\n", "", spec_md)  # the page section has its own heading
    spec_html = md_to_html(spec_md) if spec_md else "<p>Spec not written yet.</p>"
    page = page.replace("{{SPEC}}", spec_html)
    page = page.replace("{{SOUND}}", sound_block())
    page = page.replace("{{DEMO}}", (HERE / "demo.js").read_text(encoding="utf-8"))
    bad = [c for c in page if ord(c) > 127]
    if bad:
        sys.exit("non-ASCII characters in the built page: %r" % sorted(set(bad))[:10])
    (HERE / "index.html").write_text(page, encoding="utf-8")
    print("wrote", HERE / "index.html", len(page.encode()), "bytes")


if __name__ == "__main__":
    main()
