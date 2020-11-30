# Git Tools


## git-info.sh

### Motivation

This is mainly used for GitHub Actions to figure out if a current build (independently of PR, push or cronjob) is on a specific branch or tag or something else.

### GitHub Actions

```yaml
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2
        with:
          fetch-depth: 0

      - name: Set variables
        id: vars
        run: |
          # BRANCH, TAG or COMMIT
          GIT_TYPE="$( \
            curl -sS https://raw.githubusercontent.com/cytopia/git-tools/master/git-info.sh \
            | sh \
            | grep '^GIT_TYPE' \
            | sed 's|.*=||g' \
          )"
          # Branch name, Tag name or Commit Hash
          GIT_SLUG="$( \
            curl -sS https://raw.githubusercontent.com/cytopia/git-tools/master/git-info.sh \
            | sh \
            | grep '^GIT_NAME' \
            | sed 's|.*=||g' \
          )"
          # Export variable for later stage
          # https://docs.github.com/en/free-pro-team@latest/actions/reference/workflow-commands-for-github-actions#environment-files
          echo "GIT_TYPE=${GIT_TYPE}" >> $GITHUB_ENV
          echo "GIT_SLUG=${GIT_SLUG}" >> $GITHUB_ENV

      - name: Publish docker image
        run: |
          # Use git tag name or git branch name as docker tag
          docker push image:${GIT_SLUG}
```

### See usage in action

Will output the correct git name and type:

Branch: `release-0.24`
```bash
$ git-info.sh
GIT_NAME=release-0.24
GIT_TYPE=BRANCH
GIT_HEAD=892f8fc

DETACHED_FROM=
BEHIND=0
```

HEAD detached at `a78bccfd` (latest commit in `master` branch)
```bash
$ git-info.sh
GIT_NAME=master
GIT_TYPE=BRANCH
GIT_HEAD=a78bccf

DETACHED_FROM=master
BEHIND=0
```

Git tag `0.9` (tag in `master` branch)
```bash
$ git-info.sh
GIT_NAME=0.9
GIT_TYPE=TAG
GIT_HEAD=a7bdd40

DETACHED_FROM=master
BEHIND=0
```

HEAD detached at `05faee2` (two commits behind `master` branch)
```bash
$ git-info.sh
GIT_NAME=05faee2
GIT_TYPE=COMMIT
GIT_HEAD=05faee2

DETACHED_FROM=master
BEHIND=2
```
