resource "google_storage_bucket" "buckets" {
  for_each = var.buckets
  
  name          = each.value.name
  location      = each.value.location
  storage_class = each.value.storage_class
  force_destroy = each.value.force_destroy
  
  labels = each.value.labels

  versioning {
    enabled = each.value.versioning_enabled
  }

  uniform_bucket_level_access = each.value.uniform_bucket_level_access

  public_access_prevention = each.value.public_access_prevention

  dynamic "lifecycle_rule" {
    for_each = each.value.lifecycle_rules
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lifecycle_rule.value.action.storage_class
      }
      condition {
        age                   = lifecycle_rule.value.condition.age
        created_before        = lifecycle_rule.value.condition.created_before
        with_state           = lifecycle_rule.value.condition.with_state
        matches_storage_class = lifecycle_rule.value.condition.matches_storage_class
        num_newer_versions   = lifecycle_rule.value.condition.num_newer_versions
      }
    }
  }
}