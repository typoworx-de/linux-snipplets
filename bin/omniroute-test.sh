#!/usr/bin/env bash

set -u

baseUrl="${1:-}"
apiKey="${2:-}"

if [[ -z "${baseUrl}" ]]
then
  echo "Usage:"
  echo "  ${0} https://omniroute.example.net/v1 [API_KEY]"
  exit 1
fi

baseUrl="${baseUrl%/}"
modelsUrl="${baseUrl}/models"

runTest()
{
  local label="${1}"
  shift

  local responseFile
  responseFile="$(mktemp)"

  local httpCode
  httpCode="$(
    curl \
      --silent \
      --show-error \
      --output "${responseFile}" \
      --write-out '%{http_code}' \
      "$@" \
      "${modelsUrl}"
  )"

  echo
  echo "=== ${label} ==="
  echo "URL: ${modelsUrl}"
  echo "HTTP status: ${httpCode}"
  echo "Response:"

  if command -v jq >/dev/null 2>&1
  then
    jq . "${responseFile}" 2>/dev/null || cat "${responseFile}"
  else
    cat "${responseFile}"
  fi

  echo
  rm -f "${responseFile}"
}

runTest \
  "Request without API key"

if [[ -n "${apiKey}" ]]
then
  runTest \
    "Request with API key" \
    --header "Authorization: Bearer ${apiKey}"

  runTest \
    "Request with invalid API key" \
    --header "Authorization: Bearer invalid-test-key"
else
  echo
  echo "No API key supplied. The authenticated test was skipped."
fi
