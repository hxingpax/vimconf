# Git change history commiter info
git filter-branch -f --env-filter "GIT_AUTHOR_NAME='galaxyhuang'; GIT_AUTHOR_EMAIL='galaxyhuang@tencent.com'; GIT_COMMITTER_NAME='galaxyhuang'; GIT_COMMITTER_EMAIL='galaxyhuang@tencent.com';" HEAD~5..HEAD
