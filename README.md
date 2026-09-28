# Zhiming Zhang's Personal Website

An English personal website built with [Academic Pages](https://github.com/academicpages/academicpages.github.io) and hosted on GitHub Pages.

Website: https://zhimingzhang2005.github.io

## Update content

- `_config.yml`: identity, contact links, and site settings.
- `_pages/about.md`: homepage.
- `_pages/cv.md`: current online CV.
- `_data/cv.json`: optional structured CV data.
- `_data/navigation.yml`: navigation.
- `images/zhiming-avatar.png`: profile image; update `author.avatar` in `_config.yml` to use a different file.

## Add a note

Create `_posts/YYYY-MM-DD-short-title.md` with front matter such as:

```yaml
---
title: "Your note title"
date: 2026-09-28
excerpt: "A brief summary."
comments: false
share: false
---
```

Write the note in Markdown below the front matter. It will appear automatically on `/notes/`.

## Preview

On this Windows computer, use the configured Ubuntu runtime:

```powershell
.\site.cmd preview
```

Open http://localhost:4000. See [the local maintenance guide](LOCAL_DEVELOPMENT.md) for editing, adding notes, building, and publishing.

For a separate Ruby environment:

```sh
bundle install
bundle exec jekyll serve
```

## Build

```sh
JEKYLL_ENV=production bundle exec jekyll build --strict_front_matter
```

GitHub Actions checks builds on pull requests and pushes to `master`. The repository's existing GitHub Pages configuration publishes the website.

The Academic Pages theme and its license are retained.
