#!/bin/sh
set -e
if $AUTO_SEARCH_TF_DIR ; then
    WORKING_DIRS=$(sh -c 'find . -type f -name "*.tf" -exec dirname {} \;|sort -u'  2>&1)
else
    WORKING_DIRS="${TF_ACTION_WORKING_DIR:-.}"
fi

set +e
# Iterate through each directory and build up a comment.
SUCCESS=0
for dir in $WORKING_DIRS; do
LINT_COMMENT=$(sh -c "cd $dir && terraform get && tflint --error-with-issues" 2>&1)
RETURN=$?
echo "$dir"
echo "$LINT_COMMENT"
if [ $RETURN -eq 0 ]; then
    continue
fi
SUCCESS=1
LINT_COMMENT_NO_COLOR=$(echo "$LINT_COMMENT" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})*)?m//g")
LINT_OUTPUT="$LINT_OUTPUT
<summary><code>$dir</code></summary>

\`\`\`
$LINT_COMMENT_NO_COLOR
\`\`\`

"
done

if [ $SUCCESS -eq 0 ]; then
    exit $SUCCESS
fi

COMMENT="#### \`tflint\` Failed
$LINT_OUTPUT
"
PAYLOAD=$(echo '{}' | jq --arg body "$COMMENT" '.body = $body')
COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url)
curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$PAYLOAD" "$COMMENTS_URL" > /dev/null

exit $SUCCESS