#!/bin/bash

# Usage: get_latest_release 'vendor/repo-name'
get_latest_release()
{
  curl -s "https://api.github.com/repos/${1}/tags" | jq --raw-output '.[0].name';
  return $?;
}
