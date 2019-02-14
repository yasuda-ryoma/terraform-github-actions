# Terraform Fmt Action
Runs `terraform fmt` to validate all Terraform files in a directory are in the canonical format.
 If any files differ, this action will comment back on the pull request with the diffs of each file.

See [https://www.terraform.io/docs/github-actions/actions/fmt.html](https://www.terraform.io/docs/github-actions/actions/fmt.html).

# ❗Important❗️Environment Variables

* `TF_ACTION_WORKING_DIR`
  * Directory to execute Terraform on (defaults to starting directory `.`)
* `TF_ACTION_COMMENT`
  * If set to `"false"` will not post comments to Github 
