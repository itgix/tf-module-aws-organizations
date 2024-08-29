####################################
# Tag Policies
####################################

locals {
  policy_files = { for f in fileset("${path.module}/tag-policies", "*.json") : 
                   split(".", basename(f))[0] => {
                     name = split(".", basename(f))[0],
                     path = f
                   }
                 }
}

resource "aws_organizations_policy" "tag_policy" {
  for_each = local.policy_files

  name        = each.value.name
  description = "Tag policy - ${each.value.name}"
  content     = file("${path.module}/tag-policies/${each.value.path}")
  type        = "TAG_POLICY"
}

# Attach a common policy like 'Required Tags' to the root to reflect all OUs
resource "aws_organizations_policy_attachment" "common_policy_attachment" {
  policy_id = aws_organizations_policy.tag_policy["required-tags"].id
  target_id = aws_organizations_organization.default.roots[0].id
}  ## TODO add cost center tag as required

#        "CostCenter": {
#           "tag_key": {
#                "@@assign": "CostCenter"
#            }
#        }

resource "aws_organizations_policy_attachment" "dev_policy_attachment" {
  policy_id = aws_organizations_policy.tag_policy["dev"].id
  target_id = aws_organizations_account.ou_non_prod1.id
}

resource "aws_organizations_policy_attachment" "stage_policy_attachment" {
  policy_id = aws_organizations_policy.tag_policy["stage"].id
  target_id = aws_organizations_account.ou_non_prod2.id
}

resource "aws_organizations_policy_attachment" "production_policy_attachment" {
  policy_id = aws_organizations_policy.tag_policy["production"].id
  target_id = aws_organizations_account.ou_prod1.id
}

resource "aws_organizations_policy_attachment" "management_policy_attachment" {
  policy_id = aws_organizations_policy.tag_policy["management"].id
  target_id = aws_organizations_organization.default.master_account_id
}

resource "aws_organizations_policy_attachment" "shared_services_policy_attachment" {
  policy_id = aws_organizations_policy.tag_policy["shared-services"].id
  target_id = aws_organizations_account.ou_main1.id
}

resource "aws_organizations_policy_attachment" "audit_policy_attachment" {
  policy_id = aws_organizations_policy.tag_policy["audit"].id
  target_id = aws_organizations_account.ou_main1.id
}
