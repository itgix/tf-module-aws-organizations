# DynamoDB doesn't support ABAC so we cannot restrict creating dynamodb tables without tags
# RDS has a bug with AWS console where when you create an RDS cluster with tags, its tags are not propagated down to the RDS instance and if we have an SCP that restricts creation of RDS instances without tags, we encounter this problem where an RDS aurora cluster cannot be created from AWS console, it does not affect creating an RDS instance, and it also does not affect creating an RDS cluster from SDK or CLI
# EC2 instances create and attach volumes, so SCP must include both "instance/*" and "volume/*" to avoid failures.
# ElastiCache Replication Group depends on parameter groups, so SCP must target "replicationgroup:*" to avoid unintended denials.
# prevent creation of resources without mandatory tags - Application, Environment, CostCenter, Project
resource "aws_organizations_policy" "tagging_policy" {
  content     = templatefile("${path.module}/scp-policies/tagging.json", {})
  name        = "Tagging Policy"
  type        = "SERVICE_CONTROL_POLICY"
  description = "SCP that enforces having mandatory tags on resources"
}

# allow only some regions to be used
resource "aws_organizations_policy" "region_policy" {
  content = templatefile("${path.module}/scp-policies/regions.json.tpl", {
    allowed_regions = var.allowed_regions
  })
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
# prevent disabling a KMS key, deleting custom key store, scheduling key for deletion and disabling key rotation
# prevent deletion of cloudtrail in all accounts
# prevent S3 upload without encryption
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
  name        = "Cloudtrail Logs Policy"
  type        = "SERVICE_CONTROL_POLICY"
  description = "SCP that restricts deleting Cloudtrail logs from the Audit account's S3 bucket"
}

# policy that can be used to quarantine an account or OU by restricting access to all services except a specific role that can be used for investigating security incidents
# TODO: prepare a quarantine role in all accounts
resource "aws_organizations_policy" "quarantine_policy" {
  content = templatefile("${path.module}/scp-policies/quarantine-policy.json.tpl", {
    dev_account             = var.dev_account
    staging_account         = var.staging_account
    prod_account            = var.prod_account
    logging_account         = var.logging_account
    shared_services_account = var.shared_services_account
  })
  name        = "Quarantine Policy"
  type        = "SERVICE_CONTROL_POLICY"
  description = "SCP that can be assigned on any account or OU to quarantine it by restricting access to all services except a certain role that will be used for security incident investigation"
}

# protect the access to the management account from the Identity Center delegated admin account (usually Security)
# the delegated admin cannot change permission sets / assignments of the management account, but it can change group
# memberships, users and the identity source - this SCP denies (from the accounts it is attached to):
#   - membership / group changes on the protected groups and updates / deletion of the protected users
#   - administrator password / MFA resets (sso-directory has no resource-level permissions, so it applies to all users - optional)
#   - identity source, external IdP, SCIM provisioning and directory MFA settings changes
# the management account is not affected by SCPs, so these changes remain possible only from the management account
# created only when identity_center_protected_account_ids is set, attached to those accounts in attach-scp.tf
resource "aws_organizations_policy" "identity_center_protection" {
  count = length(var.identity_center_protected_account_ids) + length(var.identity_center_protected_account_names) > 0 ? 1 : 0

  content = templatefile("${path.module}/scp-policies/identity-center-protection.json.tpl", {
    protected_group_arns  = [for id in var.identity_center_protected_group_ids : "arn:aws:identitystore:::group/${id}"]
    protected_user_arns   = [for id in var.identity_center_protected_user_ids : "arn:aws:identitystore:::user/${id}"]
    deny_credential_reset = var.identity_center_protection_deny_credential_reset
  })
  name        = "Identity Center Protection Policy"
  type        = "SERVICE_CONTROL_POLICY"
  description = "SCP for the Identity Center delegated admin account - prevents escalation to the management account through group memberships, users, credentials or identity source changes"
}
