#!/bin/bash

#
# Read the value of an option.
function readopt() {
  filter=$1
  next=false
  for var in "${@:2}"; do
    if $next; then
      echo $var
      break;
    fi
    if [ "$var" = "$filter" ]; then
      next=true
    fi
  done
}

#
# Returns the first argument if not empty, the second otherwise
function or() {
  if [ -n "$1" ]; then
    echo $1
  else
    echo $2
  fi
}

function do_create() {
    for i in `seq 1 $num`;
    do
        repo="${prefix}$i"
        echo "Creating $repo"
       # mkdir -p $repo
        #pushd $repo
      #  git init
      #  git remote add origin git@github.com:${org}/${repo}.git
        hub create $org/$repo
     #   popd
    done    
}

function do_delete() {
    for i in `seq 1 $num`;
    do
        repo="${prefix}$i"
        echo "Deleting $repo"
        hub delete -y $org/$repo
    done    
}
#
# Print a usage message.
function usage() {
    echo "Batch create github repositories on Github.
Usage:

hub tool is a pre-requisite (brew install hub).

repos.sh create|delete [options].

--num           The number of repositories to create, defaults to 3.
--prefix        The prefix of the repository to create, defaults to 'user'.
--github-org    The name of the organization that will host the repositories, defaults to current user.


Examples:

./scripts/repo.sh create --github-org rhte-us --num 100
./scripts/repo.sh delete --github-org rhte-us --num 100

./scripts/repo.sh create --github-org rhte-eu --num 100
./scripts/repo.sh delete --github-org rhte-eu --num 100
"
}

action=$1
org=$(or $(readopt --github-org $*) $(whoami))
num=$(or $(readopt --num $*) 3)
prefix=$(or $(readopt --prefix $*) "user")

if [ -x "$(command -v "hub")" ]; then
    echo "hub detected."
else
    echo "hub not detected. Please install hub and try again."
    exit 1
fi

if [ "$1" == "create" ]; then
    echo "Creating $num $prefix repos in github org: $org under $(pwd)."
    do_create
elif [ "$1" == "delete" ]; then
    echo "Deleting $num $prefix repos from github org: $org."
    do_delete
fi
