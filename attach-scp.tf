## Root of organization policies
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

resource "aws_organizations_policy_attachment" "combined_org_policy" {
  policy_id = aws_organizations_policy.combined_org_policy.id
  target_id = aws_organizations_organization.default.roots[0].id
}

## OUs policies
# EBS - prod
resource "aws_organizations_policy_attachment" "prevent_unencrypt_ebs_prod" {
  policy_id = aws_organizations_policy.prevent_ebs_unencrypt_policy.id
  target_id = aws_organizations_organizational_unit.prod.id
}

# EBS - non-prod
resource "aws_organizations_policy_attachment" "prevent_unencrypt_ebs_non_prod" {
  policy_id = aws_organizations_policy.prevent_ebs_unencrypt_policy.id
  target_id = aws_organizations_organizational_unit.non_prod.id
}

## Cloudtrail - main
#resource "aws_organizations_policy_attachment" "prevent_cloudtrail_delete_main" {
#policy_id = aws_organizations_policy.prevent_cloudtrail_delete.id
#target_id = aws_organizations_organizational_unit.main.id
#}

## Cloudtrail - non-prod
#resource "aws_organizations_policy_attachment" "prevent_cloudtrail_delete_non_prod" {
#policy_id = aws_organizations_policy.prevent_cloudtrail_delete.id
#target_id = aws_organizations_organizational_unit.non_prod.id
#}

## Cloudtrail - prod
#resource "aws_organizations_policy_attachment" "prevent_cloudtrail_delete_prod" {
#policy_id = aws_organizations_policy.prevent_cloudtrail_delete.id
#target_id = aws_organizations_organizational_unit.prod.id
#}

## Accounts policies
resource "aws_organizations_policy_attachment" "cloudtrail_logs" {
  policy_id = aws_organizations_policy.prevent_cloudtrail_logs_delete.id
  # attach to Loggging and Audit account
  target_id = aws_organizations_organizational_unit.main.accounts[1].id
}
