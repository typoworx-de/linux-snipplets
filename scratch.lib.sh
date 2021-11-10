#!/bin/bash

function scratchGit()
{
  gitRoot=$(realpath ${scratchGitRoot});
  git --git-dir=${gitRoot}/.git --work-tree=${gitRoot} $@
}
