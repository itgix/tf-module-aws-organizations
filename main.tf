# Create the AWS Organization
resource "aws_organizations_organization" "default" {
  aws_service_access_principals = var.service_access_principals

  enabled_policy_types = var.enabled_policy_types

  feature_set = "ALL"
}

# Create Organizational Units (OUs)
resource "aws_organizations_organizational_unit" "ous" {
  for_each  = toset(keys(var.accounts))
  name      = each.key
  parent_id = aws_organizations_organization.default.roots[0].id

  // when OUs are imported, Terraform still tried to replace them even though they match the IDs that are already in the state
  lifecycle {
    ignore_changes = [parent_id]
  }
}

# Create accounts in their respective OUs
resource "aws_organizations_account" "accounts" {
  for_each = merge([
    for ou_name, ou_accounts in var.accounts : {
      for acc_name, acc_data in ou_accounts :
      "${acc_name}" => merge(acc_data, {
        name = acc_name
        ou   = ou_name
      })
    }
  ]...)

  name      = each.value.name
  email     = each.value.email
  parent_id = aws_organizations_organizational_unit.ous[each.value.ou].id

  # role created by AWS Organizations in the new account, trusted by the management account - used to bootstrap the account
  role_name                  = each.value.role_name
  iam_user_access_to_billing = each.value.iam_user_access_to_billing
  # false = on destroy the account is only removed from the organization, true = the account is closed
  close_on_deletion = each.value.close_on_deletion

  tags = each.value.tags

  lifecycle {
    # role_name and iam_user_access_to_billing are used only when the account is created and are not returned by the
    # AWS API, so for accounts that were imported or created outside of Terraform they would force a replacement (role_name is ForceNew)
    ignore_changes = [role_name, iam_user_access_to_billing]
  }
}

# Tag policy attachments
# resource "aws_organizations_policy_attachment" "ou_prod_tag_policy_attachment" {
#  policy_id = aws_organizations_policy.ou_prod_tag_policy.id
#  target_id = aws_organizations_organizational_unit.prod.id
# }

# resource "aws_organizations_policy_attachment" "ou_main_tag_policy_attachment" {
#  policy_id = aws_organizations_policy.ou_main_tag_policy.id
#  target_id = aws_organizations_organizational_unit.prod.id
# }

# resource "aws_organizations_policy_attachment" "ou_non_prod_tag_policy_attachment" {
#  policy_id = aws_organizations_policy.ou_non_prod_tag_policy.id
#  target_id = aws_organizations_organizational_unit.prod.id
# }
