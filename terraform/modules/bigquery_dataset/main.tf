resource "google_service_account" "service_accounts" {
  for_each = var.service_accounts

  account_id   = each.value.account_id
  display_name = each.value.display_name
}

resource "google_bigquery_dataset" "datasets" {
  for_each = var.datasets

  dataset_id                 = each.value.dataset_id
  friendly_name              = each.value.friendly_name
  description                = each.value.description
  location                   = each.value.location
  default_table_expiration_ms = each.value.default_table_expiration_ms

  labels = each.value.labels

  dynamic "access" {
    for_each = each.value.access_rules
    content {
      role          = access.value.role
      
      user_by_email = access.value.user_by_email != null ? (
        contains(keys(google_service_account.service_accounts), access.value.user_by_email) ?
        google_service_account.service_accounts[access.value.user_by_email].email :
        access.value.user_by_email
      ) : null
      iam_member = access.value.iam_member != null ? access.value.iam_member : null
      domain = access.value.domain

      dynamic "dataset" {
        for_each = access.value.dataset_access != null ? [access.value.dataset_access] : []
        content {
          dataset {
            project_id = dataset.value.project_id
            dataset_id = dataset.value.dataset_id
          }
          target_types = dataset.value.target_types
        }
      }
    }
  }
}