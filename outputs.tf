# TODO: can this be taken from some form of mapping of account name to id to make those more reliable
# TODO: verify that this returns correct account ids
output "shared_services_account_id" {
  value = aws_organizations_organizational_unit.main.accounts[0].id
}

output "audit_account_id" {
  value = aws_organizations_organizational_unit.main.accounts[1].id
}

output "security_account_id" {
  value = aws_organizations_organizational_unit.main.accounts[2].id
}

output "dev_account_id" {
  value = aws_organizations_organizational_unit.non_prod.accounts[0].id
}

output "stage_account_id" {
  value = aws_organizations_organizational_unit.non_prod.accounts[1].id
}

output "prod_account_id" {
  value = aws_organizations_organizational_unit.prod.accounts[0].id
}
