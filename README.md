The Terraform module is used by the ITGix AWS Landing Zone - https://itgix.com/itgix-landing-zone/

# AWS Organizations Terraform Module

This module manages AWS Organizations including organizational units, accounts, service control policies (SCPs), tag policies, delegated administrators, and backup policies.

Part of the [ITGix AWS Landing Zone](https://itgix.com/itgix-landing-zone/).

## Resources Created

- AWS Organization with configurable policy types
- Organizational units and accounts
- Service Control Policies (SCPs) with OU attachments
- Tag policies with root/OU/account attachments
- Delegated administrator registrations
- *(Optional)* Backup policy

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `service_access_principals` | List of service access principals | `list(string)` | — | yes |
| `enabled_policy_types` | Enabled policy types for the organization | `list(string)` | — | yes |
| `accounts` | Map of accounts grouped by OU | `map(map(object({email=string})))` | `{}` | no |
| `scp_attachments` | List of SCP policy to OU attachment objects | `list(object({policy_name=string, ou_name=string}))` | `[]` | no |
| `tag_policy_attachments` | List of tag policy attachments to root, OUs, or accounts | `list(object({policy_name=string, target_type=string, target_key=string}))` | — | yes |
| `management_account_id` | AWS Organizations management account ID | `string` | — | yes |
| `delegated_admins` | Accounts to register as delegated admins for services | `list(object({account_id=string, service_principal=string}))` | — | yes |
| `include_backup_policy` | Whether to attach a backup-specific Organizations policy | `bool` | `false` | no |
| `backup_admin_account_id` | Delegated admin account ID for backup service | `string` | `""` | no |
| `attach_default_policies` | Whether to attach the default SCP policies | `bool` | `true` | no |
| `allowed_regions` | JSON-formatted string of allowed AWS regions | `string` | — | yes |
| `dev_account` | Account ID for development | `string` | — | yes |
| `staging_account` | Account ID for staging | `string` | — | yes |
| `prod_account` | Account ID for production | `string` | — | yes |
| `logging_account` | Account ID for logging and audit | `string` | — | yes |
| `shared_services_account` | Account ID for shared services | `string` | — | yes |
| `logging_and_auditing_environment_tag` | Environment tag value for audit tagging policy | `string` | `"audit"` | no |
| `dev_environment_tag` | Environment tag value for dev tagging policy | `string` | `"dev"` | no |
| `management_environment_tag` | Environment tag value for management tagging policy | `string` | `"management"` | no |
| `production_environment_tag` | Environment tag value for production tagging policy | `string` | `"production"` | no |
| `shared_services_environment_tag` | Environment tag value for shared services tagging policy | `string` | `"shared-services"` | no |
| `staging_environment_tag` | Environment tag value for staging tagging policy | `string` | `"stage"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `account_ids` | Map of account logical names to their AWS account IDs |
| `account_names` | List of account names |

## Usage Example

```hcl
module "organizations" {
  source = "path/to/tf-module-aws-organizations"

  service_access_principals = [
    "guardduty.amazonaws.com",
    "securityhub.amazonaws.com"
  ]

  enabled_policy_types = ["SERVICE_CONTROL_POLICY", "TAG_POLICY"]
  management_account_id = "111111111111"

  accounts = {
    Workloads = {
      dev   = { email = "dev@example.com" }
      stage = { email = "stage@example.com" }
      prod  = { email = "prod@example.com" }
    }
  }

  delegated_admins = [
    {
      account_id        = "222222222222"
      service_principal = "guardduty.amazonaws.com"
    }
  ]

  tag_policy_attachments = []
  allowed_regions        = "[\"eu-central-1\", \"us-east-1\"]"
  dev_account            = "333333333333"
  staging_account        = "444444444444"
  prod_account           = "555555555555"
  logging_account        = "666666666666"
  shared_services_account = "777777777777"
}
```
