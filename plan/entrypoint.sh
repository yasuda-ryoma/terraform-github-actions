#!/bin/sh
set -e

############## CONFIGURATION
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

if [ -n "$INFRA_BOOKING_CORE_SSH_KEY" ] ; then
    # Prepare SSH key and settings to be able to pull TF modules from Github
    mkdir -p $HOME/.ssh/
    echo "$INFRA_BOOKING_CORE_SSH_KEY" > $HOME/.ssh/id_rsa
    chmod 600 $HOME/.ssh/id_rsa

    echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
    echo "Host github \n HostName github.com
    User git
    IdentityFile $HOME/.ssh/id_rsa
    IdentitiesOnly yes" >> /etc/ssh/ssh_config

    git config --global url."git@github.com:".insteadOf "https://github.com/"
fi

WORKSPACE=${TF_ACTION_WORKSPACE:-default}

OVERALL_STATUS_CODE=0

############## EXECUTION

export AWS_ACCESS_KEY_ID="$TF_PLAN_AWS_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$TF_PLAN_AWS_SECRET_ACCESS_KEY"

for dir in ${TF_ACTION_WORKING_DIR_PATHS//:/ }; do

  echo ">>> Executing plan for directory $dir"
  set +e
  OUTPUT=$(sh -c "cd $dir && terraform init -no-color && terraform workspace select $WORKSPACE && TF_IN_AUTOMATION=true terraform plan -no-color -input=false $*" 2>&1)
  SUCCESS=$?
  echo "$OUTPUT"
  set -e

  # If no plan fails, this action exits with status 0 (success). Otherwise exit with status 1 (error).
  if [ $SUCCESS -ne 0 ]; then
    OVERALL_STATUS_CODE=1
  fi

  if [ "$TF_ACTION_COMMENT" = "1" ] || [ "$TF_ACTION_COMMENT" = "false" ]; then
      continue
  fi

  COMMENT=""

  # If not successful, post failed plan output.
  # Comment text contents are based on Github Markdown
  if [ $SUCCESS -ne 0 ]; then
COMMENT="### Terraform Plan Result ($dir)

\`\`\`diff
- \`terraform plan\` on directory $dir FAILED
\`\`\`
---
<details>
<summary>Cick to see details</summary>

\`\`\`
$OUTPUT
\`\`\`
</details>"
  else
      FMT_PLAN=$(echo "$OUTPUT" | sed -r -e 's/^  \+/\+/g' | sed -r -e 's/^  ~/~/g' | sed -r -e 's/^  -/-/g')
      COMMENT="### Terraform Plan Result ($dir)

\`\`\`diff
+ \`terraform plan\` on $dir SUCCEEDED
\`\`\`
---
<details><summary>Cick to see details</summary>

\`\`\`diff
$FMT_PLAN
aaaa
\`\`\`
</details>"
  fi

  PAYLOAD=$(echo '{}' | jq --arg body "$COMMENT" '.body = $body')
  COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url)
  curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$PAYLOAD" "$COMMENTS_URL" > /dev/null
done

exit $OVERALL_STATUS_CODE
