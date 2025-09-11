resource "aws_iam_organizations_features" "itgix_landing_zone" {
  enabled_features = [
    "RootCredentialsManagement",
    "RootSessions"
  ]
}
