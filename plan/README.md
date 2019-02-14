# Terraform Plan Action
Runs `terraform plan` and comments back on the pull request with the plan output.

See [https://www.terraform.io/docs/github-actions/actions/plan.html](https://www.terraform.io/docs/github-actions/actions/plan.html).

# ❗Important❗️Environment Variables

* `TF_PLAN_AWS_ACCESS_KEY_ID`
  * AccessKeyID to be used in the AWSCli (can be defined in cleartext)
* `TF_PLAN_AWS_SECRET_ACCESS_KEY`
  * SecretKey to be used in the AWSCli (must be secret)
* `TF_ACTION_WORKSPACE`
  * Workspace to be used by Terraform
* `INFRA_BOOKING_CORE_SSH_KEY`
  * Private-Key to be used to pull modules from Infra-Booking-Core (must be secret)
* `TF_ACTION_WORKING_DIR_PATHS`
  * Path string defining all folders to run `terraform plan` in. Separated by `:`. Example `"./base:./common:./stg:./prd"`
* `TF_ACTION_COMMENT`
  * If set to `"false"` will not post comments to Github 
