variable "service_access_principals" {
  type        = list(string)
  description = "List of service access principals"
}

variable "enabled_policy_types" {
  type        = list(string)
  description = "Enabled policy types for the organization"
}

# Accounts to create under each OU
variable "accounts" {
  description = "Map of accounts grouped by OU"
  type = map(map(object({
    email = string
  })))
  default = {}
}

# Attach SCPs to OUs
variable "scp_attachments" {
  description = "List of SCP policy to OU attachment objects"
  type = list(object({
    policy_name = string
    ou_name     = string
  }))
  default = []
}

# Attach tag policies to root, OUs, or accounts
variable "tag_policy_attachments" {
  description = "List of tag policy attachments to root, OUs, or accounts"
  type = list(object({
    policy_name = string
    target_type = string # one of: "root", "account", "ou"
    target_key  = string # key from corresponding resource maps
  }))
}

variable "management_account_id" {
  description = "AWS Organizations management account ID"
  type        = string
}

# List of delegated service admins
variable "delegated_admins" {
  type = list(object({
    account_id        = string
    service_principal = string
  }))
  description = "Accounts to register as delegated admins for services"
}


# Enable backup-specific policy
variable "include_backup_policy" {
  description = "Whether to attach a backup-specific Organizations policy"
  type        = bool
  default     = false
}


# Delegated admin for backup
variable "backup_admin_account_id" {
  description = "Delegated admin account ID for backup service"
  type        = string
  default     = ""
}

# SCPs
variable "allowed_regions" {
  type        = string
  description = "A JSON-formatted string representing a list of AWS regions allowed by the SCP or tag policy templates. Example: \"[\\\"us-east-1\\\", \\\"eu-central-1\\\"]\". This value is inserted directly into policy templates and must be a valid JSON array of strings."
  default     = "[\"us-east-1\", \"eu-central-1\"]"
}

variable "dev_account" {
  type        = string
  description = "Account ID for development"
}

variable "staging_account" {
  type        = string
  description = "Account ID for staging"
}

variable "prod_account" {
  type        = string
  description = "Account ID for production"
}

variable "logging_account" {
  type        = string
  description = "Account ID for logging and audit"
}

variable "shared_services_account" {
  type        = string
  description = "Account ID for shared services"
}

# Tagging Policies
variable "logging_and_auditing_environment_tag" {
  type        = string
  default     = "audit"
  description = "Environment tag value used in the audit tagging policy."
}

variable "dev_environment_tag" {
  type        = string
  default     = "dev"
  description = "Environment tag value used in the development tagging policy."
}

variable "management_environment_tag" {
  type        = string
  default     = "management"
  description = "Environment tag value used in the management tagging policy."
}

variable "production_environment_tag" {
  type        = string
  default     = "production"
  description = "Environment tag value used in the production tagging policy."
}

variable "shared_services_environment_tag" {
  type        = string
  default     = "shared-services"
  description = "Environment tag value used in the shared services tagging policy."
}

variable "staging_environment_tag" {
  type        = string
  default     = "stage"
  description = "Environment tag value used in the staging tagging policy."
}
