# Root of organization policies
resource "aws_organizations_policy_attachment" "tagging_policy" {
  policy_id = aws_organizations_policy.tagging_policy.id
  target_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "region_policy" {
  policy_id = aws_organizations_policy.region_policy.id
  target_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "prevent_tf_delete_policy" {
  policy_id = aws_organizations_policy.prevent_tf_delete_policy.id
  target_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "iam_user_policy" {
  policy_id = aws_organizations_policy.iam_user_policy.id
  target_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "cloudtrail_policy" {
  policy_id = aws_organizations_policy.prevent_cloudtrail_delete.id
  target_id = aws_organizations_organization.default.roots[0].id
}

# OUs policies
resource "aws_organizations_policy_attachment" "prevent_unencrypt_ebs_prod" {
  policy_id = aws_organizations_policy.prevent_ebs_unencrypt_policy.id
  target_id = aws_organizations_organizational_unit.prod.id
}

resource "aws_organizations_policy_attachment" "prevent_unencrypt_ebs_non_prod" {
  policy_id = aws_organizations_policy.prevent_ebs_unencrypt_policy.id
  target_id = aws_organizations_organizational_unit.non_prod.id
}

#resource "aws_organizations_policy_attachment" "ou_main_policy_attachment" {
#policy_id = aws_organizations_policy.tagging_policy.id
#target_id = aws_organizations_organizational_unit.main.id
#}

# Accounts policies
resource "aws_organizations_policy_attachment" "cloudtrail_logs" {
  policy_id = aws_organizations_policy.prevent_cloudtrail_logs_delete.id
  target_id = aws_organizations_organizational_unit.main.accounts[1].id
}
