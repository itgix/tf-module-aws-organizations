variable "service_access_principals" {
  type        = list(string)
  description = "List of service access principals"
}

variable "enabled_policy_types" {
  type        = list(string)
  description = "Enabled policy types for the organization"
}


####################### NEW ORG MODULE ###########################
variable "accounts" {
  description = "Map of accounts grouped by OU"
  type = map(map(object({
    email = string
  })))
  default = {}
}

# ################### Map for policy attachment ###################
variable "scp_attachments" {
  description = "List of SCP policy to OU attachment objects"
  type = list(object({
    policy_name = string
    ou_name     = string
  }))
  default = []
}

variable "tag_policy_attachments" {
  description = "List of tag policy attachments to root, OUs, or accounts"
  type = list(object({
    policy_name = string
    target_type = string # one of: "root", "account", "ou"
    target_key  = string # key from corresponding resource maps
  }))
}
