#!/bin/bash

dir_name=`basename $(pwd)`
org_name=${1:-}
repo_name=${2:-}

if [ "$org_name" = "" ]; then
 echo "Github Org name (rhte-eu or rhte-us)?"
 read org_name
fi

if [ "$repo_name" = "" ]; then
 echo "Repo name (hit enter to use '$dir_name')?"
 read repo_name
fi

if [ "$repo_name" = "" ]; then
 repo_name=$dir_name
fi

username="rhte-user"
token="!demo12345"

echo -e "Creating Github repository '$repo_name' under '$org_name' ..."
echo "curl -u "xxxxx:yyyyy" https://api.github.com/orgs/$org_name/repos -d '{"name":"'$repo_name'", "description":"My cool '$repo_name'", "private": false, "has_issues": false, "has_projects": true, "has_wiki":false }'"
curl -u "$username:$token" https://api.github.com/orgs/$org_name/repos -d '{"name":"'$repo_name'", "description":"My cool '$repo_name'", "private": false, "has_issues": false, "has_projects": true, "has_wiki":false }' > /dev/null 2>&1
echo "Created git repo: https://github.com/$org_name/$repo_name."