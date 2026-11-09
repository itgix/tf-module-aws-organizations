output "organization_id" {
  description = "ID of the AWS Organization"
  value       = aws_organizations_organization.default.id
}

output "organization_arn" {
  description = "ARN of the AWS Organization"
  value       = aws_organizations_organization.default.arn
}

output "root_id" {
  description = "ID of the organization root"
  value       = aws_organizations_organization.default.roots[0].id
}

output "organizational_unit_ids" {
  description = "Map of OU names to their IDs"
  value = {
    for key, ou in aws_organizations_organizational_unit.ous :
    key => ou.id
  }
}

output "account_ids" {
  description = "Map of account logical names to their AWS account IDs"
  value = {
    for key, acc in aws_organizations_account.accounts :
    key => acc.id
  }
}

output "account_names" {
  description = "List of account names"
  value       = [for acc in aws_organizations_account.accounts : acc.name]
}
