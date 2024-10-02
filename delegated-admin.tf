resource "aws_organizations_delegated_administrator" "security_account" {
  account_id        = aws_organizations_account.ou_main3.id
  service_principal = "principal"
}
