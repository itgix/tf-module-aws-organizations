# Opt-in (enable) Regions org-wide. Requires all features + trusted access for
# "account.amazonaws.com". Enabling is async and may take up to several hours per account.

# Management account (omitting account_id targets the caller).
resource "aws_account_region" "management" {
  for_each = toset(var.opt_in_regions)

  region_name = each.value
  enabled     = true
}

# Member accounts managed by this module: one opt-in per account/region pair.
resource "aws_account_region" "members" {
  for_each = {
    for pair in setproduct(keys(aws_organizations_account.accounts), var.opt_in_regions) :
    "${pair[0]}-${pair[1]}" => {
      account_id  = aws_organizations_account.accounts[pair[0]].id
      region_name = pair[1]
    }
  }

  account_id  = each.value.account_id
  region_name = each.value.region_name
  enabled     = true
}
