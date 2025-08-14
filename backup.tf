# Resource policy for centralized AWS Backup
resource "aws_organizations_resource_policy" "backup" {
  count = var.include_backup_policy ? 1 : 0

  content = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowOrganizationsRead",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.backup_admin_account_id}:root"
        },
        Action = [
          "organizations:Describe*",
          "organizations:List*",
          "organizations:TagResource",
          "organizations:UntagResource"
        ],
        Resource = "*"
      },
      {
        Sid    = "AllowBackupPoliciesCreation",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.backup_admin_account_id}:root"
        },
        Action   = "organizations:CreatePolicy",
        Resource = "*"
      },
      {
        Sid    = "AllowBackupPoliciesModification",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.backup_admin_account_id}:root"
        },
        Action = [
          "organizations:DescribePolicy",
          "organizations:UpdatePolicy",
          "organizations:DeletePolicy"
        ],
        Resource = "arn:aws:organizations::${var.management_account_id}:policy/*/backup_policy/*",
        Condition = {
          StringEquals = {
            "organizations:PolicyType" = "BACKUP_POLICY"
          }
        }
      },
      {
        Sid    = "AllowBackupPoliciesAttachmentAndDetachment",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${var.backup_admin_account_id}:root"
        },
        Action = [
          "organizations:AttachPolicy",
          "organizations:DetachPolicy"
        ],
        Resource = [
          "arn:aws:organizations::${var.management_account_id}:root/*",
          "arn:aws:organizations::${var.management_account_id}:ou/*",
          "arn:aws:organizations::${var.management_account_id}:account/*",
          "arn:aws:organizations::${var.management_account_id}:policy/*/backup_policy/*"
        ],
        Condition = {
          StringEquals = {
            "organizations:PolicyType" = "BACKUP_POLICY"
          }
        }
      }
    ]
  })
}

