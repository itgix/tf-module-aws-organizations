# Register delegated admins for services
# An entry references the account either by account_name (key in var.accounts, for accounts created
# by this module - the ID is not known before apply) or by account_id (accounts not managed by this module).
# The for_each key has to be known at plan time, so it is built from the name/ID given in the input and never
# from the ID of an account created by this module.
resource "aws_organizations_delegated_administrator" "this" {
  for_each = {
    for d in var.delegated_admins : "${coalesce(d.account_name, d.account_id)}-${d.service_principal}" => d
  }

  account_id        = each.value.account_name != null ? aws_organizations_account.accounts[each.value.account_name].id : each.value.account_id
  service_principal = each.value.service_principal
}
