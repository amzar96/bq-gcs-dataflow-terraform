output "tag_template_names" {
  value = {
    for k, v in google_data_catalog_tag_template.tag_templates : k => v.name
  }
}

output "tag_template_ids" {
  value = {
    for k, v in google_data_catalog_tag_template.tag_templates : k => v.tag_template_id
  }
}

output "tag_names" {
  value = {
    for k, v in google_data_catalog_tag.tags : k => v.name
  }
}

output "tag_templates" {
  value = google_data_catalog_tag_template.tag_templates
}

output "tags" {
  value = google_data_catalog_tag.tags
}