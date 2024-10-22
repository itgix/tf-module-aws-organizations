####################################
# Service Control Policies
####################################

# DynamoDB doesn't support ABAC so we cannot restrict creating dynamodb tables without tags
# RDS has a bug with AWS console where when you create an RDS cluster with tags, its tags are not propagated down to the RDS instance and if we have an SCP that restricts creation of RDS instances without tags, we encounter this problem where an RDS aurora cluster cannot be created from AWS console, it does not affect creating an RDS instance, and it also does not affect creating an RDS cluster from SDK or CLI
resource "aws_organizations_policy" "tagging_policy" {
  content     = templatefile("${path.module}/scp-policies/tagging-policy.json", {})
  name        = "Tagging Policy"
  type        = "SERVICE_CONTROL_POLICY"
  description = "SCP that enforces having mandatory tags on resources"
}

resource "aws_organizations_policy" "region_policy" {
  content     = templatefile("${path.module}/scp-policies/region-policy.json", {})
  name        = "Region Policy"
  type        = "SERVICE_CONTROL_POLICY"
  description = "SCP that restricts access to allowed AWS regions"
}

# resource "aws_organizations_policy" "ou_prod_policy" {
#   content     = templatefile("${path.module}/scp-policies/ou-prod-scp-policies.json", {})
#   name        = "OU Prod Policies"
#   type        = "SERVICE_CONTROL_POLICY"
#   description = "SCPs for OU Prod"
# }

# resource "aws_organizations_policy" "ou_main_policy" {
#   content     = templatefile("${path.module}/scp-policies/ou-main-scp-policies.json",{})
#   name        = "OU Main Policies"
#   type        = "SERVICE_CONTROL_POLICY"
#   description = "SCPs for OU Main"
# }

# resource "aws_organizations_policy" "ou_non_prod_policy" {
#   content     = templatefile("${path.module}/scp-policies/ou-non-prod-scp-policies.json",{})
#   name        = "OU Non Prod Policies"
#   type        = "SERVICE_CONTROL_POLICY"
#   description = "SCPs for OU Non Prod"
# }
