# AI Engineering Knowledge Booklet

A single-page, searchable field guide to 50 AI engineering concepts, from tokens and
context windows up to multi-agent orchestration and production ops. Every concept has a
one-line definition, a "quick grasp" explanation, a deep dive, and links to primary sources.

No build step, no dependencies, no tracking — one self-contained HTML file.

## Files

| File | What it is |
|---|---|
| `index.html` | **The page that gets served.** Already generated and ready to push. Self-contained: all CSS, JS and content inline. |
| `index.template.html` | The source file, with `__PLACEHOLDERS__` for the URLs. `configure.sh` reads this. Don't delete it. |
| `og-image-v2.png` | 1200×630 preview card shown when the link is posted to LinkedIn/Slack/X. |
| `configure.sh` | Regenerates `index.html` from the template. Only needed if you change a URL. |

## Publishing to GitHub Pages

**1. Nothing to configure — unless you change the repo name.**

`index.html` is already generated for `https://jsitla.github.io/AI-Knowledge-Booklet/`, so the
repo **must be named `AI-Knowledge-Booklet`** for the preview image to resolve. If you'd
rather call it something else, open `configure.sh`, change `SITE_URL` to match, and re-run:

```bash
bash configure.sh
```

The `SITE_URL` must end with a trailing slash. This matters more than it looks: `og:image`
has to be an absolute URL, so if it points at the wrong repo name LinkedIn shows a blank
grey card instead of the preview.

The same script is where you add your LinkedIn profile — set `LINKEDIN_URL` and re-run, and
your name in the byline plus a "Connect with me on LinkedIn" line in the footer both become
links. Left empty, the page simply omits them.

**2. Create the repo and push.**

```bash
git init
git add .
git commit -m "AI Engineering Knowledge Booklet"
git branch -M main
git remote add origin https://github.com/jsitla/AI-Knowledge-Booklet.git
git push -u origin main
```

If you'd rather not use the command line, create the repo on github.com and drag these
files into the upload box — it works exactly the same.

**3. Turn on Pages.** In the repo: **Settings → Pages → Build and deployment**.
Set *Source* to **Deploy from a branch**, *Branch* to **main**, folder **/ (root)**, then Save.
Give it a minute or two; the URL appears at the top of that same page.

**4. Check the preview card.** Paste the live URL into
[LinkedIn's Post Inspector](https://www.linkedin.com/post-inspector/). It shows the card
exactly as it will appear and re-scrapes the page — useful because LinkedIn caches
aggressively, so if you post first and fix the tags after, the old (or blank) card can
stick around for a long time. Inspect *before* you post.

## Using a custom domain instead

If you'd rather serve it from your own domain:

1. Put your domain in `configure.sh` as `SITE_URL` (e.g. `https://example.com/ai-booklet/`)
   and re-run it.
2. Add a file named `CNAME` containing just your domain.
3. Point a `CNAME` DNS record at `<your-username>.github.io` (or, for an apex domain, four
   `A` records at GitHub's Pages IPs — GitHub's docs list the current ones).
4. In **Settings → Pages**, enter the custom domain and tick *Enforce HTTPS* once the
   certificate is issued.

## Updating the content later

Edit `index.template.html`, then run `bash configure.sh` to regenerate `index.html` — if you
edit `index.html` directly, your changes are overwritten the next time that script runs.

All 50 concepts live in three `<script>` blocks near the bottom of the file, as a plain
JavaScript array. Each entry looks like:

```js
{lv:3, t:"Title", o:"One-liner shown collapsed",
 q:"Quick grasp paragraph",
 d:["Deep dive paragraph 1","Deep dive paragraph 2"],
 links:[{k:"docs", t:"Link title", u:"https://…"}]}
```

`lv` is the level (1–5). Add an entry to the array and it appears automatically — the level
headings, the counter and the search index all build themselves from the data.

One thing to keep an eye on: the header says "Compiled July 2026" and the content is frozen
at that point. If you keep the page up for a while, either update it or soften that line.

## Licence

The concept explanations are original text; the linked sources belong to their respective
authors. Add whatever licence you prefer before sharing widely — if you want people to reuse
it freely, a `LICENSE` file with CC BY 4.0 is a common choice for written material like this.
