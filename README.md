# Git Tools


## git-info.sh

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
