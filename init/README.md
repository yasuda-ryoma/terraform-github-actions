# Terraform Init Action
Runs `terraform init` to initialize a Terraform working directory. This action will comment back on the pull request on failure.

See [https://www.terraform.io/docs/github-actions/actions/init.html](https://www.terraform.io/docs/github-actions/actions/init.html).

# ❗Important❗️Environment Variables

* `TF_ACTION_WORKING_DIR`
  * Directory to execute Terraform on (defaults to starting directory `.`)
* `TF_ACTION_COMMENT`
  * If set to `"false"` will not post comments to Github 
