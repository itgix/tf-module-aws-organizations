# Register delegated admins for services
resource "aws_organizations_delegated_administrator" "this" {
  for_each = {
    for d in var.delegated_admins : "${d.account_id}-${d.service_principal}" => d
  }

  account_id        = each.value.account_id
  service_principal = each.value.service_principal
}
