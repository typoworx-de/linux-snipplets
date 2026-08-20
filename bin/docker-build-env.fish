set connectionName "TYPOworx Office"
set remoteBuilder "x3400-build"

if nmcli -t -f NAME connection show --active \
    | grep -Fxq "$connectionName"
    set -gx BUILDX_BUILDER "$remoteBuilder"
else
    set -e BUILDX_BUILDER
end

if set -q BUILDX_BUILDER
    echo "Docker buildx context: $BUILDX_BUILDER"
else
    echo "Docker buildx context: <unset>"
end
