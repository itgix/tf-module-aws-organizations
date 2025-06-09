# TODO: verify that this returns correct account ids
########### NEW OUTPUTS ##############

output "account_ids" {
  description = "Map of account logical names to their AWS account IDs"
  value = {
    for key, acc in aws_organizations_account.accounts :
    key => acc.id
  }
}

output "account_names" {
  value = [for acc in aws_organizations_account.accounts : acc.name]
}