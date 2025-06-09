resource "aws_organizations_organization" "default" {
  aws_service_access_principals = var.service_access_principals

  enabled_policy_types = var.enabled_policy_types

  feature_set = "ALL"
}

####################### NEW OU MAP ##############################
resource "aws_organizations_organizational_unit" "ous" {
  for_each  = toset(keys(var.accounts))
  name      = each.key
  parent_id = aws_organizations_organization.default.roots[0].id
}

###################### NEW ACCOUNTS #############################
resource "aws_organizations_account" "accounts" {
  for_each = merge([
    for ou_name, ou_accounts in var.accounts : {
      for acc_name, acc_data in ou_accounts :
      "${acc_name}" => {
        name  = acc_name
        email = acc_data.email
        ou    = ou_name
      }
    }
  ]...)

  name      = each.value.name
  email     = each.value.email
  parent_id = aws_organizations_organizational_unit.ous[each.value.ou].id
}



######################################
# Attaching Tag Policies to Org Units  
######################################

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
