#!/usr/bin/env bash
_PWD=$(pwd);
projectRoot=$(realpath $(dirname $(dirname $0)));

declare -A _color=(\
    ['reset']='\033[0m' \
    ['black']='\E[0;47m'\
    ['red']='\E[0;31m'\
    ['green']='\E[0;32m'\
    ['yellow']='\E[0;33m'\
    ['blue']='\E[0;34m'\
    ['magenta']='\E[0;35m'\
    ['cyan']='\E[0;36m'\
    ['white']='\E[0;37m'\
);

function syntax()
{
    scriptName=$(basename $0);
    echo -e "${_color[blue]}Syntax:${_color[reset]} ${scriptName}";
    echo -e "${scriptName} list";
    echo -e "${scriptName} pull [module-name optional, all if unset]";
    echo -e "${scriptName} update [module-name optional, all if unset]";
}

function gitModuleName()
{
    subgitPath=$(realpath ${1});
    name=$(basename ${subgitPath});

    echo -e "${_color[blue]} ${name} ${_color[reset]}";
}

function gitModuleInfo()
{
    subgitPath=$(realpath ${1});
    subgitBranch=$(cd ${subgitPath}; git branch 2>/dev/null | grep '^*' | colrm 1 2);
    subgitCommitId=$(cd ${subgitPath}; git rev-parse HEAD | head -c 8);

    echo -e "   Branch: ${subgitBranch}";
    echo -e "   Commit-Id: ${subgitCommitId}";
}

function gitStatus()
{
    if [[ ! -z ${1} ]];
    then
        if [[ ! -d ${projectRoot}/typo3conf/ext/${1} ]];
        then
            echo -e "${_color[red]}Error unknown sub-git with name ${name}${_color[reset]}";
            return 1;
        fi
          gitModuleName ${projectRoot}/typo3conf/ext/${1};
          gitModuleInfo ${projectRoot}/typo3conf/ext/${1};
    else
        for subgit in $(find "${projectRoot}/typo3conf/ext" -type d -name '.git');
        do
          subgitPath=$(dirname $(realpath ${subgit}));
          gitModuleName ${subgitPath}
          gitModuleInfo ${subgitPath};
        done
    fi
}

function gitPull()
{
    if [[ ! -d ${1} ]];
    then
        echo -e "${_color[red]}Error unknown path '${1}'${_color[reset]}";
        return 1;
    fi

    subgitPath=$(realpath ${1});
    subgitBranch=$(cd ${subgitPath}; git branch 2>/dev/null | grep '^*' | colrm 1 2);

    gitModuleName ${subgitPath};

    cd ${subgitPath}; git pull origin ${subgitBranch} 2>/dev/null || {
      echo -e "${_color[red]}Error pulling ${name}${_color[reset]}";
    }

    gitModuleInfo ${subgitPath};
    echo "";

    cd ${_pwd};
}

function updateModules()
{
    moduleName=$1;

    if [[ ! -z ${moduleName} ]];
    then
        if [[ ! -d ${projectRoot}/typo3conf/ext/${moduleName} ]];
        then
            echo -e "${_color[red]}Error unknown sub-git with name ${name}${_color[reset]}";
            return 1;
        fi

        gitPull ${projectRoot}/typo3conf/ext/${moduleName};
    else
        for subgit in $(find "${projectRoot}/typo3conf/ext" -type d -name '.git');
        do
          subgitPath=$(dirname $(realpath ${subgit}));
          gitPull ${subgitPath};
        done
    fi
}

case "$1" in
    status)  gitStatus "$2";;
    update)  updateModules $2;;
    *)       syntax; exit 1;;
esac

cd ${_PWD};
