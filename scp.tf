# DynamoDB doesn't support ABAC so we cannot restrict creating dynamodb tables without tags
# RDS has a bug with AWS console where when you create an RDS cluster with tags, its tags are not propagated down to the RDS instance and if we have an SCP that restricts creation of RDS instances without tags, we encounter this problem where an RDS aurora cluster cannot be created from AWS console, it does not affect creating an RDS instance, and it also does not affect creating an RDS cluster from SDK or CLI
# prevent creation of resources without mandatory tags - Application, Environment, CostCenter, Project
resource "aws_organizations_policy" "tagging_policy" {
  content     = templatefile("${path.module}/scp-policies/tagging.json", {})
  name        = "Tagging Policy"
  type        = "SERVICE_CONTROL_POLICY"
  description = "SCP that enforces having mandatory tags on resources"
}

# allow only some regions to be used
resource "aws_organizations_policy" "region_policy" {
  content     = templatefile("${path.module}/scp-policies/regions.json", {})
  name        = "Region Policy"
  type        = "SERVICE_CONTROL_POLICY"
  description = "SCP that restricts access to allowed AWS regions"
}

# prevent deletion of s3 bucket or state file inside it
resource "aws_organizations_policy" "prevent_tf_delete_policy" {
  content     = templatefile("${path.module}/scp-policies/tf-state.json", {})
  name        = "Terraform State Policy"
  type        = "SERVICE_CONTROL_POLICY"
  description = "SCP that prevents deletion of S3 bucket or Terraform state inside it"
}

# prevent creation of IAM users or access keys - they should be created only Identity Center
# prevent any AWS account from leaving the organization
# prevent deletion of cloudtrail in all accounts
resource "aws_organizations_policy" "combined_org_policy" {
  content     = templatefile("${path.module}/scp-policies/combined-org-policy.json", {})
  name        = "Combined Org Policy"
  type        = "SERVICE_CONTROL_POLICY"
  description = "Combined Organizational SCP that restricts IAM user creation, disabling of EBS volume restriction, and accounts to be able to leave the organization"
}

# prevent disabled EBS volume encryption in application accounts
resource "aws_organizations_policy" "prevent_ebs_unencrypt_policy" {
  content     = templatefile("${path.module}/scp-policies/ebs-encryption.json", {})
  name        = "Prevent EBS Unencrypt Policy"
  type        = "SERVICE_CONTROL_POLICY"
  description = "SCP that restricts disabling encryption on EBS volumes"
}

# prevent deletion of cloudtrail logs in audit account
resource "aws_organizations_policy" "prevent_cloudtrail_logs_delete" {
  content     = templatefile("${path.module}/scp-policies/cloudtrail-logs.json", {})
  name        = "Cloudtrail Policy"
  type        = "SERVICE_CONTROL_POLICY"
  description = "SCP that restricts deleting Cloudtrail logs from the Audit account's S3 bucket"
}
