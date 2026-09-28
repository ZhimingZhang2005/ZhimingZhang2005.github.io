# Zhiming Zhang's Personal Website

An English personal website built with [Academic Pages](https://github.com/academicpages/academicpages.github.io) and hosted on GitHub Pages.

Website: https://zhimingzhang2005.github.io

## Update content

- `_config.yml`: identity, contact links, and site settings.
- `_pages/about.md`: homepage.
- `_pages/projects.md`: short project descriptions.
- `_pages/cv.md`: current online CV.
- `_data/cv.json`: optional structured CV data.
- `_data/navigation.yml`: navigation.
- `images/zhiming-initials.svg`: initials avatar; replace it and update `author.avatar` to add a photo.

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
