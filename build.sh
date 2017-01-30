#!/bin/sh

set -e

if [ -n "${ATLASSIAN_VERSION}" ]; then
    atlassian_version=${ATLASSIAN_VERSION}
else
    atlassian_version="$(curl -s https://my.atlassian.com/download/feeds/jira-software.rss | grep -Eo "(\d{1,2}\.){2,3}\d" | uniq)";
fi

branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$branch" = "HEAD" ]; then
    echo "Invalid branch."
    exit 1
fi

if [ "$branch" = "master" ]; then
    VERSION=${atlassian_version} make build upload clean
else
	VERSION=${atlassian_version}-${branch} ATLASSIAN_VERSION=${atlassian_version} make build upload clean
fi
