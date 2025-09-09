The Terraform module is used by the ITGix AWS Landing Zone - https://itgix.com/itgix-landing-zone/


<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_organizations_account.accounts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_account) | resource |
| [aws_organizations_delegated_administrator.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_delegated_administrator) | resource |
| [aws_organizations_organization.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organization) | resource |
| [aws_organizations_organizational_unit.ous](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_organizational_unit) | resource |
| [aws_organizations_policy.combined_org_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) | resource |
| [aws_organizations_policy.prevent_cloudtrail_logs_delete](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) | resource |
| [aws_organizations_policy.prevent_ebs_unencrypt_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) | resource |
| [aws_organizations_policy.prevent_tf_delete_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) | resource |
| [aws_organizations_policy.quarantine_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) | resource |
| [aws_organizations_policy.region_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) | resource |
| [aws_organizations_policy.tag_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) | resource |
| [aws_organizations_policy.tagging_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) | resource |
| [aws_organizations_policy_attachment.combined_org_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) | resource |
| [aws_organizations_policy_attachment.prevent_tf_delete_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) | resource |
| [aws_organizations_policy_attachment.region_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) | resource |
| [aws_organizations_policy_attachment.scp_to_ou](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) | resource |
| [aws_organizations_policy_attachment.tag_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) | resource |
| [aws_organizations_policy_attachment.tagging_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) | resource |
| [aws_organizations_resource_policy.backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_resource_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accounts"></a> [accounts](#input\_accounts) | Map of accounts grouped by OU | <pre>map(map(object({<br/>    email = string<br/>  })))</pre> | `{}` | no |
| <a name="input_allowed_regions"></a> [allowed\_regions](#input\_allowed\_regions) | A JSON-formatted string representing a list of AWS regions allowed by the SCP or tag policy templates. Example: "[\"us-east-1\", \"eu-central-1\"]". This value is inserted directly into policy templates and must be a valid JSON array of strings. | `string` | `"[\"us-east-1\", \"eu-central-1\"]"` | no |
| <a name="input_backup_admin_account_id"></a> [backup\_admin\_account\_id](#input\_backup\_admin\_account\_id) | Delegated admin account ID for backup service | `string` | `""` | no |
| <a name="input_delegated_admins"></a> [delegated\_admins](#input\_delegated\_admins) | Accounts to register as delegated admins for services | <pre>list(object({<br/>    account_id        = string<br/>    service_principal = string<br/>  }))</pre> | n/a | yes |
| <a name="input_dev_account"></a> [dev\_account](#input\_dev\_account) | Account ID for development | `string` | n/a | yes |
| <a name="input_dev_environment_tag"></a> [dev\_environment\_tag](#input\_dev\_environment\_tag) | Environment tag value used in the development tagging policy. | `string` | `"dev"` | no |
| <a name="input_enabled_policy_types"></a> [enabled\_policy\_types](#input\_enabled\_policy\_types) | Enabled policy types for the organization | `list(string)` | n/a | yes |
| <a name="input_include_backup_policy"></a> [include\_backup\_policy](#input\_include\_backup\_policy) | Whether to attach a backup-specific Organizations policy | `bool` | `false` | no |
| <a name="input_logging_account"></a> [logging\_account](#input\_logging\_account) | Account ID for logging and audit | `string` | n/a | yes |
| <a name="input_logging_and_auditing_environment_tag"></a> [logging\_and\_auditing\_environment\_tag](#input\_logging\_and\_auditing\_environment\_tag) | Environment tag value used in the audit tagging policy. | `string` | `"audit"` | no |
| <a name="input_management_account_id"></a> [management\_account\_id](#input\_management\_account\_id) | AWS Organizations management account ID | `string` | n/a | yes |
| <a name="input_management_environment_tag"></a> [management\_environment\_tag](#input\_management\_environment\_tag) | Environment tag value used in the management tagging policy. | `string` | `"management"` | no |
| <a name="input_prod_account"></a> [prod\_account](#input\_prod\_account) | Account ID for production | `string` | n/a | yes |
| <a name="input_production_environment_tag"></a> [production\_environment\_tag](#input\_production\_environment\_tag) | Environment tag value used in the production tagging policy. | `string` | `"production"` | no |
| <a name="input_scp_attachments"></a> [scp\_attachments](#input\_scp\_attachments) | List of SCP policy to OU attachment objects | <pre>list(object({<br/>    policy_name = string<br/>    ou_name     = string<br/>  }))</pre> | `[]` | no |
| <a name="input_service_access_principals"></a> [service\_access\_principals](#input\_service\_access\_principals) | List of service access principals | `list(string)` | n/a | yes |
| <a name="input_shared_services_account"></a> [shared\_services\_account](#input\_shared\_services\_account) | Account ID for shared services | `string` | n/a | yes |
| <a name="input_shared_services_environment_tag"></a> [shared\_services\_environment\_tag](#input\_shared\_services\_environment\_tag) | Environment tag value used in the shared services tagging policy. | `string` | `"shared-services"` | no |
| <a name="input_staging_account"></a> [staging\_account](#input\_staging\_account) | Account ID for staging | `string` | n/a | yes |
| <a name="input_staging_environment_tag"></a> [staging\_environment\_tag](#input\_staging\_environment\_tag) | Environment tag value used in the staging tagging policy. | `string` | `"stage"` | no |
| <a name="input_tag_policy_attachments"></a> [tag\_policy\_attachments](#input\_tag\_policy\_attachments) | List of tag policy attachments to root, OUs, or accounts | <pre>list(object({<br/>    policy_name = string<br/>    target_type = string # one of: "root", "account", "ou"<br/>    target_key  = string # key from corresponding resource maps<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_ids"></a> [account\_ids](#output\_account\_ids) | Map of account logical names to their AWS account IDs |
| <a name="output_account_names"></a> [account\_names](#output\_account\_names) | n/a |
<!-- END_TF_DOCS -->
