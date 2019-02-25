# Terraform Lint Action
Runs `terraform lint` and comments back on the pull request with the lint output in case of failure.

See [TFLint](https://github.com/wata727/tflint).

# ❗Important❗️Environment Variables

* `AUTO_SEARCH_TF_DIR`
  * If defined enables the automatic search for directories containing .tf files.
* `TF_ACTION_WORKING_DIR`
  * Directory to execute Terraform on (defaults to starting directory `.`)
* `INFRA_BOOKING_CORE_SSH_KEY`
  * Private-Key to be used to pull modules from Infra-Booking-Core (must be secret)
* `FLAGS`
  * tflint's options (example: `--ignore-module="../../"`)
