output "datasets" {
  description = "BigQuery datasets"
  value = {
    for k, v in google_bigquery_dataset.datasets : k => {
      dataset_id  = v.dataset_id
      id          = v.id
      project     = v.project
      location    = v.location
      self_link   = v.self_link
      etag        = v.etag
      description = v.description
      labels      = v.labels
    }
  }
}

output "service_accounts" {
  description = "Service accounts"
  value = {
    for k, v in google_service_account.service_accounts : k => {
      account_id   = v.account_id
      email        = v.email
      display_name = v.display_name
      name         = v.name
      unique_id    = v.unique_id
    }
  }
}