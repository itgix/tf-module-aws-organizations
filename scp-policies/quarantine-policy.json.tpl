{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyAllAWSServicesExceptBreakglassRoles",
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:PrincipalArn": [
            "arn:aws:iam::${dev_account}:role/security-incident-response",
            "arn:aws:iam::${staging_account}:role/security-incident-response",
            "arn:aws:iam::${prod_account}:role/security-incident-response",
            "arn:aws:iam::${logging_account}:role/security-incident-response",
            "arn:aws:iam::${shared_services_account}:role/security-incident-response"
          ]
        }
      }
    }
  ]
}