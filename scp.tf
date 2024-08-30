####################################
# Service Control Policies
####################################

resource "aws_organizations_policy" "shared_policy" {
  content     = templatefile("${path.module}/scp-policies/shared-scp.json", {})
  name        = "Shared SCP"
  type        = "SERVICE_CONTROL_POLICY"
  description = "SCPs shared for all environments"
}

## TODO: add below requirements in the policy
# {
#   "Sid": "DenyCreateSecretWithNoCostCenterTag",
#   "Effect": "Deny",
#   "Action": "secretsmanager:CreateSecret",
#   "Resource": "*",
#   "Condition": {
#     "Null": {
#       "aws:RequestTag/CostCenter": "true"
#     }
#   }
# },
# {
#   "Sid": "DenyRunInstanceWithNoCostCenterTag",
#   "Effect": "Deny",
#   "Action": "ec2:RunInstances",
#   "Resource": [
#     "arn:aws:ec2:*:*:instance/*",
#     "arn:aws:ec2:*:*:volume/*"
#   ],
#   "Condition": {
#     "Null": {
#       "aws:RequestTag/CostCenter": "true"
#     }
#   }
# }

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
