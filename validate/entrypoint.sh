#!/bin/sh
set -e
set -x 

if $AUTO_SEARCH_TF_DIR ; then
    WORKING_DIRS=$(sh -c 'find . -type f -name "*.tf" -not -path "**/.*/*" -exec dirname {} \;|sort -u'  2>&1)
else
    WORKING_DIRS="${TF_ACTION_WORKING_DIR:-.}"
fi

# Iterate through each directory and build up a comment.
SUCCESS=0
for dir in $WORKING_DIRS; do

if [ -n "$TF_ACTION_WORKSPACE" ] ; then
    VALIDATE_COMMENT=$(sh -c "cd $dir && terraform workspace select $TF_ACTION_WORKSPACE && terraform validate -no-color $*" 2>&1);
else
    VALIDATE_COMMENT=$(sh -c "cd $dir && terraform validate -no-color $*" 2>&1);
fi

RETURN=$?
echo "$dir"
echo "$VALIDATE_COMMENT"
if [ $RETURN -eq 0 ]; then
    continue
fi
SUCCESS=$RETURN
VALIDATE_OUTPUT="$VALIDATE_OUTPUT
<summary><code>$dir</code></summary>

\`\`\`
$VALIDATE_COMMENT
\`\`\`

"
done

if [ $SUCCESS -eq 0 ]; then
    exit $SUCCESS
fi

COMMENT="#### \`terraform validate\` Failed
$LINT_OUTPUT
"
PAYLOAD=$(echo '{}' | jq --arg body "$COMMENT" '.body = $body')
COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url)
curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$PAYLOAD" "$COMMENTS_URL" > /dev/null

exit $SUCCESS

