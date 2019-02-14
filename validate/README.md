# Terraform Validate Action
Runs `terraform validate` to validate the terraform files in a directory.

See [https://www.terraform.io/docs/github-actions/actions/validate.html](https://www.terraform.io/docs/github-actions/actions/validate.html).

# ❗Important❗️Environment Variables

* `AUTO_SEARCH_TF_DIR`
  * If defined enables the automatic search for directories containing .tf files.
* `TF_ACTION_WORKING_DIR`
  * Directory to execute Terraform on (defaults to starting directory `.`)
* `TF_ACTION_WORKSPACE`
  * Workspace to be used by Terraform
