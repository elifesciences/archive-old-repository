#!/bin/bash
# 'archive' a github repository on s3
 
set -e
remote_repo=$1
remote_repo_dir="$remote_repo.git"
loc="public"

if [ -z "$remote_repo" ]; then
    echo "repository name required"
    exit 1
fi

#

echo "detecting if $remote_repo is public"
if [ "404" -eq $(curl --location --head --write-out "%{http_code}\n" --silent --output /dev/null "http://github.com/elifesciences/$remote_repo") ]; then
    echo "... it's private"
    loc="private"
else
    echo "... it's public"
fi
loc="./s3/$loc"
mkdir -p $loc

#

echo "fetching archived repositories from s3"
aws s3 sync s3://elife-archived-github-repos "./s3"
local_repo_dir="$loc/$remote_repo_dir" # ll ./s3/private/foo-repo.git

#

if [ -d $local_repo_dir ]; then
    echo "repository found in archive ($local_repo_dir)"
    mv $local_repo_dir $remote_repo_dir
fi

if [ -d $remote_repo_dir ]; then
    echo "updating $remote_repo"
    (
        cd $remote_repo_dir
        git remote update &> /dev/null || echo "failed to update from origin (origin may no longer exist)"
    )
else
    echo "cloning"
    git clone --mirror "ssh://git@github.com/elifesciences/$remote_repo"
fi

#

mv $remote_repo_dir $loc

echo "pushing archived repositories back to s3"
aws s3 sync "./s3" s3://elife-archived-github-repos

echo "done"
