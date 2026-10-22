{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyIdentitySourceChanges",
      "Effect": "Deny",
      "Action": [
        "sso:AssociateDirectory",
        "sso:DisassociateDirectory",
        "sso:CreateTrust",
        "sso:UpdateTrust",
        "sso:PutMfaDeviceManagementForDirectory",
        "sso-directory:CreateExternalIdPConfigurationForDirectory",
        "sso-directory:UpdateExternalIdPConfigurationForDirectory",
        "sso-directory:DeleteExternalIdPConfigurationForDirectory",
        "sso-directory:EnableExternalIdPConfigurationForDirectory",
        "sso-directory:DisableExternalIdPConfigurationForDirectory",
        "sso-directory:ImportExternalIdPCertificate",
        "sso-directory:DeleteExternalIdPCertificate",
        "sso-directory:CreateProvisioningTenant",
        "sso-directory:DeleteProvisioningTenant",
        "sso-directory:CreateBearerToken",
        "sso-directory:DeleteBearerToken"
      ],
      "Resource": "*"
    }%{ if length(protected_group_arns) > 0 },
    {
      "Sid": "DenyProtectedGroupChanges",
      "Effect": "Deny",
      "Action": [
        "identitystore:CreateGroupMembership",
        "identitystore:DeleteGroupMembership",
        "identitystore:UpdateGroup",
        "identitystore:DeleteGroup"
      ],
      "Resource": ${jsonencode(protected_group_arns)}
    }%{ endif }%{ if length(protected_user_arns) > 0 },
    {
      "Sid": "DenyProtectedUserChanges",
      "Effect": "Deny",
      "Action": [
        "identitystore:UpdateUser",
        "identitystore:DeleteUser"
      ],
      "Resource": ${jsonencode(protected_user_arns)}
    }%{ endif }%{ if deny_credential_reset },
    {
      "Sid": "DenyAdminCredentialReset",
      "Effect": "Deny",
      "Action": [
        "sso-directory:UpdatePassword",
        "sso-directory:DeleteMfaDeviceForUser",
        "sso-directory:UpdateMfaDeviceForUser",
        "sso-directory:StartVirtualMfaDeviceRegistration",
        "sso-directory:CompleteVirtualMfaDeviceRegistration",
        "sso-directory:StartWebAuthnDeviceRegistration",
        "sso-directory:CompleteWebAuthnDeviceRegistration"
      ],
      "Resource": "*"
    }%{ endif }
  ]
}
