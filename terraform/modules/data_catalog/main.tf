# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/data_catalog_tag_template
resource "google_data_catalog_tag_template" "tag_templates" {
  for_each = var.tag_templates

  tag_template_id = each.value.tag_template_id
  region          = each.value.region
  display_name    = each.value.display_name
  force_delete    = each.value.force_delete

  dynamic "fields" {
    for_each = each.value.fields
    content {
      field_id     = fields.value.field_id
      display_name = fields.value.display_name
      is_required  = fields.value.is_required

      type {
        primitive_type = fields.value.type.primitive_type

        dynamic "enum_type" {
          for_each = fields.value.type.enum_type != null ? [fields.value.type.enum_type] : []
          content {
            dynamic "allowed_values" {
              for_each = enum_type.value.allowed_values
              content {
                display_name = allowed_values.value.display_name
              }
            }
          }
        }
      }
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/data_catalog_tag
resource "google_data_catalog_tag" "tags" {
  for_each = var.tags

  parent   = each.value.parent
  template = google_data_catalog_tag_template.tag_templates[each.value.template_key].name

  dynamic "fields" {
    for_each = each.value.fields
    content {
      field_name   = fields.value.field_name
      string_value = fields.value.string_value
      double_value = fields.value.double_value
      bool_value   = fields.value.bool_value
      enum_value   = fields.value.enum_value
    }
  }
}