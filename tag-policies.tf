####################################
# Tag Policies
####################################

# 1. Collect all tag policy files and render them with the variables passed
locals {
  all_tag_policy_files = concat(
    tolist(fileset("${path.module}/tag-policies", "*.json")),
    tolist(fileset("${path.module}/tag-policies", "*.json.tpl"))
  )

  tag_policy_files = {
    for f in local.all_tag_policy_files :
    trimsuffix(trimsuffix(basename(f), ".json.tpl"), ".json") => {
      name   = trimsuffix(trimsuffix(basename(f), ".json.tpl"), ".json")
      path   = f
      is_tpl = endswith(f, ".tpl")
    }
  }
  rendered_tag_policy_content = {
    for name, value in local.tag_policy_files :
    name => value.is_tpl
    ? templatefile("${path.module}/tag-policies/${value.path}", {
      logging_and_auditing_environment_tag = var.logging_and_auditing_environment_tag,
      dev_environment_tag                  = var.dev_environment_tag,
      management_environment_tag           = var.management_environment_tag,
      production_environment_tag           = var.production_environment_tag,
      shared_services_environment_tag      = var.shared_services_environment_tag,
      staging_environment_tag              = var.staging_environment_tag
    })
    : file("${path.module}/tag-policies/${value.path}")
  }
}

# 2. Create policies from those files
resource "aws_organizations_policy" "tag_policy" {
  for_each = local.tag_policy_files

  name        = each.value.name
  description = "Tag policy - ${each.value.name}"
  content     = local.rendered_tag_policy_content[each.key]
  type        = "TAG_POLICY"
}

# 3. Map policy names to their IDs (after resource is created)
locals {
  tag_policy_map = {
    for name in keys(local.tag_policy_files) :
    name => aws_organizations_policy.tag_policy[name].id
  }
}

# 4. Build target attachments
locals {
  tag_policy_attachments = [
    for pair in var.tag_policy_attachments : {
      policy_name = pair.policy_name
      policy_id   = local.tag_policy_map[pair.policy_name]
      target_type = pair.target_type
      target_key  = pair.target_key
      target_id = (
        pair.target_type == "root" ? aws_organizations_organization.default.roots[0].id :
        pair.target_type == "account" ? aws_organizations_account.accounts[pair.target_key].id :
        pair.target_type == "ou" ? aws_organizations_organizational_unit.ous[pair.target_key].id :
        null
      )
    }
  ]
}

# 5. Attach tag policies to targets
resource "aws_organizations_policy_attachment" "tag_policy_attachment" {
  for_each = {
    for pair in local.tag_policy_attachments :
    "${pair.target_type}-${pair.target_key}-${pair.policy_name}" => pair
  }

  policy_id = each.value.policy_id
  target_id = each.value.target_id
}
