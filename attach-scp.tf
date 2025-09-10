## Root of organization policies
resource "aws_organizations_policy_attachment" "tagging_policy" {
  count     = var.remove_policy_attachments ? 0 : 1
  policy_id = aws_organizations_policy.tagging_policy.id
  target_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "region_policy" {
  count     = var.remove_policy_attachments ? 0 : 1
  policy_id = aws_organizations_policy.region_policy.id
  target_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "prevent_tf_delete_policy" {
  count     = var.remove_policy_attachments ? 0 : 1
  policy_id = aws_organizations_policy.prevent_tf_delete_policy.id
  target_id = aws_organizations_organization.default.roots[0].id
}

resource "aws_organizations_policy_attachment" "combined_org_policy" {
  count     = var.remove_policy_attachments ? 0 : 1
  policy_id = aws_organizations_policy.combined_org_policy.id
  target_id = aws_organizations_organization.default.roots[0].id
}


############### NEW METHOD FOR OU POLICIES ATTACHMENT ####################

locals {
  scp_map = {
    tagging_policy                 = aws_organizations_policy.tagging_policy.id
    region_policy                  = aws_organizations_policy.region_policy.id
    prevent_tf_delete_policy       = aws_organizations_policy.prevent_tf_delete_policy.id
    combined_org_policy            = aws_organizations_policy.combined_org_policy.id
    prevent_ebs_unencrypt_policy   = aws_organizations_policy.prevent_ebs_unencrypt_policy.id
    prevent_cloudtrail_logs_delete = aws_organizations_policy.prevent_cloudtrail_logs_delete.id
    quarantine_policy              = aws_organizations_policy.quarantine_policy.id
  }

  scp_ou_pairs = [
    for pair in var.scp_attachments : {
      policy_name = pair.policy_name
      policy_id   = local.scp_map[pair.policy_name]
      ou_name     = pair.ou_name
      ou_id       = aws_organizations_organizational_unit.ous[pair.ou_name].id
    }
  ]
}

resource "aws_organizations_policy_attachment" "scp_to_ou" {
  for_each = {
    for pair in local.scp_ou_pairs :
    #TODO: See how to move ou_name into a list 
    "${pair.ou_name}-${pair.policy_name}" => pair
  }

  policy_id = each.value.policy_id
  target_id = each.value.ou_id
}
