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
    version=${atlassian_version}
else
    version=${atlassian_version}-${branch}
fi

registry="docker.seibert-media.net"
REGISTRY="${registry}" IMAGE="seibertmedia/atlassian-jira-software" TAG="${version}" ./docker_image_missing.sh
if [ $? -ne 0 ]; then
  exit 0
fi

REGISTRY=${registry} VERSION=${version} ATLASSIAN_VERSION=${atlassian_version} make build upload clean
