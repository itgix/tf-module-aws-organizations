resource "aws_organizations_organization" "default" {
  aws_service_access_principals = var.service_access_principals

  enabled_policy_types = var.enabled_policy_types

  feature_set = "ALL"
}

resource "aws_organizations_organizational_unit" "main" {
  name      = var.ou_main
  parent_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_organizational_unit" "non_prod" {
  name      = var.ou_non_prod
  parent_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_organizational_unit" "prod" {
  name      = var.ou_prod
  parent_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_account" "ou_main1" {
  name      = var.main_accounts[0]
  email     = var.main_accounts_emails[0]
  parent_id = aws_organizations_organizational_unit.main.id
}

resource "aws_organizations_account" "ou_main2" {
  name      = var.main_accounts[1]
  email     = var.main_accounts_emails[1]
  parent_id = aws_organizations_organizational_unit.main.id
}

resource "aws_organizations_account" "ou_non_prod1" {
  name      = var.non_prod_accounts[0]
  email     = var.non_prod_accounts_emails[0]
  parent_id = aws_organizations_organizational_unit.non_prod.id
}

resource "aws_organizations_account" "ou_non_prod2" {
  name      = var.non_prod_accounts[1]
  email     = var.non_prod_accounts_emails[1]
  parent_id = aws_organizations_organizational_unit.non_prod.id
}

resource "aws_organizations_account" "ou_prod1" {
  name      = var.prod_accounts[0]
  email     = var.prod_accounts_emails[0]
  parent_id = aws_organizations_organizational_unit.prod.id
}

####################################
# Attaching SCPs to Org Units  
####################################

resource "aws_organizations_policy_attachment" "ou_prod_policy_attachment" {
  policy_id = aws_organizations_policy.ou_prod_policy.id
  target_id = aws_organizations_organizational_unit.prod.id
}

# resource "aws_organizations_policy_attachment" "ou_main_policy_attachment" {
#   policy_id = aws_organizations_policy.ou_main_policy.id
#   target_id = aws_organizations_organizational_unit.main.id
# }

# resource "aws_organizations_policy_attachment" "ou_non_prod_policy_attach" {
#   policy_id = aws_organizations_policy.ou_non_prod_policy.id
#   target_id = aws_organizations_organizational_unit.non_prod.id
# }

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
