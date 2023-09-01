alias docker-timed="time docker"
alias docker-run="docker run --rm -it"
alias docker-build="docker-timed buildx build --progress=plain --cache-to=type=inline --always-recreate-deps --build-arg BUILD_TIME=$(date +%s)"
alias docker-lint="docker run --rm -i hadolint/hadolint <"

# Docker-Composer Generic Shorthands
alias docker-compose="docker compose"
alias docker-compose-up="docker-compose-stack-up"
alias docker-compose-down="docker-compose-stack-down"
alias docker-compose-run="docker-compose-service-run"

# Build Commands
alias docker-compose-build="docker-compose build --push --build-arg BUILD_TIME=$(date +%s)"
alias docker-compose-build-up="docker-compose up --build --push --include-deps --force-recreate --always-recreate-deps --remove-orphans --wait"

# Stack Commands
alias docker-compose-stack-up="docker-compose up --always-recreate-deps --remove-orphans --wait"
alias docker-compose-stack-restart="docker-compose down; docker-compose-up"
alias docker-compose-stack-down="docker-compose down --remove-orphans -v"

# Service Commands
alias docker-compose-service-run="docker-compose run --rm"
alias docker-compose-service-rm="docker-compose rm --stop"
#alias docker-compose-service-restart="docker-compose rm --stop -f $@; docker-compose up -d $@"


function removeAlias()
{
  LC_MESSAGES=C type $1 2> /dev/null | grep -c 'aliased' > /dev/null && unalias $1;
}

removeAlias unalias docker-compose-service-restart
function docker-compose-service-restart()
{
  docker-compose rm --stop -f $@;
  docker-compose up -d $@;
}
