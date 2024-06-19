variable "ou_main" {
  description = "Name of Organizational Unit 1"
  type        = string
}

variable "main_accounts" {
  description = "List of accounts in Organizational Unit 1"
  type        = list(string)
}

variable "ou_non_prod" {
  description = "Name of Organizational Unit 2"
  type        = string
}

variable "non_prod_accounts" {
  description = "List of accounts in Organizational Unit 2"
  type        = list(string)
}

variable "ou_prod" {
  description = "Name of Organizational Unit 3"
  type        = string
}

variable "prod_accounts" {
  description = "List of accounts in Organizational Unit 3"
  type        = list(string)
}

variable "service_access_principals" {
  type        = list(string)
  description = "List of service access principals"
}

variable "enabled_policy_types" {
  type        = list(string)
  description = "Enabled policy types for the organization"
}

variable "feature_set" {
  type        = string
  description = ""
  default     = "ALL"
}

variable "main_accounts_emails" {
  type        = list(string)
  description = "Emails for the accounts in the Main OU"
}

variable "non_prod_accounts_emails" {
  type        = list(string)
  description = "Emails for the accounts in the Non Prod OU"
}

variable "prod_accounts_emails" {
  type        = list(string)
  description = "Emails for the accounts in the Prod OU"
}
