"Changes since last Release" Action
===================================

[![GitHub latest Release](https://img.shields.io/github/v/release/simbo/changes-since-last-release-action?logo=github)](https://github.com/simbo/changes-since-last-release-action/releases)
[![GitHub last Commit](https://img.shields.io/github/last-commit/simbo/changes-since-last-release-action/master?logo=github)](https://github.com/simbo/changes-since-last-release-action/commits/master)
[![Action on GitHub Marketplace](https://img.shields.io/badge/action-marketplace-orange.svg?logo=github)](https://github.com/marketplace/actions/changes-since-last-release)

A GitHub action to collect all changes to a repository since the last release.

---

<!-- TOC anchorMode:github.com -->

- [About](#about)
- [Usage](#usage)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
  - [Simple Example](#simple-example)
  - [Example with optional Inputs](#example-with-optional-inputs)
  - [Example together with "Create a Release" and "Version Check" Actions](#example-together-with-create-a-release-and-version-check-actions)
- [License](#license)

<!-- /TOC -->

---

## About

This action collects all git commit messages from a git repository since the
last git tag and provides them as output list together with the last git tag.

To make the necessary information available, the repository needs to be checked
out with tags and history.  
(e.g. using `actions/checkout` with `fetch-depth: 0`)

## Usage

### Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `line-prefix` | prefix to add to every collected commit message | String | `"- "` |
| `include-hashes` | whether or not the commit hashes should be included | Boolean | `true` |

### Outputs

| Name | Description | Type |
|------|-------------|------|
| `last-tag` | last tag from where on changes are collected | String |
| `log` | collected commit messages | String |

If the repository does not have any tags present, `last-tag` will be *null* and
`log` will be all prior commit messages.

### Simple Example

``` yml
jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: 🛎 Checkout
        uses: actions/checkout@v2
        with:
          fetch-depth: 0 # [!] we need to checkout with tags and commit history

      - name: 📋 Get Commits since last Release
        id: changes
        uses: simbo/changes-since-last-release-action@v1

      - name: 📣 Output collected Data
        run: |
          echo "Changes since ${{ steps.changes.outputs.last-tag }}:"
          echo "${{ steps.changes.outputs.log }}"
```

Output:

``` txt
Changes since 0.1.0:
- 7e6b5f6 bump version
- 4aeb444 another change
- a7d21d6 fix something
```

### Example with optional Inputs

``` yml
jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: 🛎 Checkout
        uses: actions/checkout@v2
        with:
          fetch-depth: 0 # [!] we need to checkout with tags and commit history

      - name: 📋 Get Commits since last Release
        id: changes
        uses: simbo/changes-since-last-release-action@v1
          with:
            line-prefix: "* "
            include-hashes: false

      - name: 📣 Output collected Data
        run: |
          echo "Changes since ${{ steps.changes.outputs.last-tag }}:"
          echo "${{ steps.changes.outputs.log }}"
```

Output:

``` txt
Changes since 0.1.0:
* bump version
* another change
* fix something
```

### Example together with "Create a Release" and "Version Check" Actions

A common usecase is to use this action's output together with the actions
["Create a Release"](https://github.com/marketplace/actions/create-a-release)
and
["Version Check"](https://github.com/marketplace/actions/version-check):

``` yml
jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: 🛎 Checkout
        uses: actions/checkout@v2
        with:
          fetch-depth: 0 # [!] we need to checkout with tags and commit history

      - name: 👀 Check for Version Update
        id: version
        uses: EndBug/version-check@v1
        with:
          file-url: https://unpkg.com/my-awesome-package/package.json
          static-checking: localIsNew

      - name: 📋 Get Commits since last Release
        if: steps.version.outputs.changed == 'true'
        id: changes
        uses: simbo/changes-since-last-release-action@v1

      - name: 🎁 Create Tag and GitHub Release
        if: steps.version.outputs.changed == 'true'
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: ${{ steps.version.outputs.version }}
          release_name: Release ${{ steps.version.outputs.version }}
          body: |
            Changes since ${{ steps.gitlog.outputs.lastVersion }}:
            ${{ steps.gitlog.outputs.log }}
```

## License

[MIT &copy; Simon Lepel](http://simbo.mit-license.org/)
