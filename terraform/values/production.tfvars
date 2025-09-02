environment = "production"

project = "cdp-project"
project_id = "cdp-project-${var.environment}"

tags = {
  Project     = "Customer Data Platform - CDP"
  Owner       = "data engineer"
  Email       = "data-engineer@company.com"
  Environment = "${var.project}"
}

gcs_buckets = {
  raw_data = {
    name                        = "cdp-raw-data-prod"
    location                   = "US"
    storage_class              = "STANDARD"
    versioning_enabled         = true
    force_destroy              = false
    uniform_bucket_level_access = true
    public_access_prevention   = "enforced"
    labels = {
      env   = "${var.project}"
      layer = "raw"
      team  = "data-engineering"
    }
    lifecycle_rules = [
      {
        action = {
          type = "Delete"
        }
        condition = {
          age = 365
        }
      }
    ]
  }

  staging_data = {
    name                        = "cdp-staging-data-prod"
    location                   = "US"
    storage_class              = "STANDARD"
    versioning_enabled         = true
    force_destroy              = false
    uniform_bucket_level_access = true
    public_access_prevention   = "enforced"
    labels = {
      env   = "${var.project}"
      layer = "staging"
      team  = "data-engineering"
    }
    lifecycle_rules = [
      {
        action = {
          type = "Delete"
        }
        condition = {
          age = 180
        }
      }
    ]
  }

  processed_data = {
    name                        = "cdp-processed-data-prod"
    location                   = "US"
    storage_class              = "STANDARD"
    versioning_enabled         = true
    force_destroy              = false
    uniform_bucket_level_access = true
    public_access_prevention   = "enforced"
    labels = {
      env   = "${var.project}"
      layer = "processed"
      team  = "data-engineering"
    }
    lifecycle_rules = [
      {
        action = {
          type = "Delete"
        }
        condition = {
          age = 60
        }
      }
    ]
  }
}

bq_datasets = {
  raw_data = {
    dataset_id                  = "raw_customer_data"
    friendly_name              = "Raw Customer Data"
    description                = "Raw customer data ingested from various sources"
    location                   = "US"
    default_table_expiration_ms = 7776000000 # 90 days
    labels = {
      env  = "${var.project}"
      layer = "raw"
    }
    access_rules = [
      {
        role          = "roles/bigquery.dataEditor"
        user_by_email = "admin-data-engineer@company.com"
      },
      {
        role       = "roles/bigquery.dataEditor"
        iam_member = "serviceAccount:data-processor@my-project.iam.gserviceaccount.com"
      }
    ]
  }

  processed_data = {
    dataset_id                  = "processed_customer_data"
    friendly_name              = "Processed Customer Data"
    description                = "Cleaned and processed customer data for analytics"
    location                   = "US"
    default_table_expiration_ms = 15552000000 # 180 days
    labels = {
      env  = "${var.project}"
      layer = "processed"
    }
    access_rules = [
      {
        role          = "roles/bigquery.dataViewer"
        user_by_email = "analytics-team@company.com"
      },
      {
        role          = "roles/bigquery.dataViewer"
        domain        = "company.com"
      },
      {
        role       = "roles/bigquery.dataEditor"
        iam_member = "serviceAccount:data-processor@my-project.iam.gserviceaccount.com"
      }
    ]
  }

  analytics = {
    dataset_id                  = "customer_analytics"
    friendly_name              = "Customer Analytics"
    description                = "Customer analytics and insights"
    location                   = "US"
    default_table_expiration_ms = 31536000000 # 365 days
    labels = {
      env  = "${var.project}"
      layer = "analytics"
    }
    access_rules = [
      {
        role          = "roles/bigquery.dataViewer"
        domain        = "company.com"
      }
    ]
  }
}

service_accounts = {
  data_ingestion = {
    account_id   = "cdp-data-ingestion"
    display_name = "CDP Data Ingestion Service Account"
  }

  data_processing = {
    account_id   = "cdp-data-processing"
    display_name = "CDP Data Processing Service Account"
  }

  analytics_service = {
    account_id   = "cdp-project-service"
    display_name = "CDP Analytics Service Account"
  }
}

data_catalog_tag_templates = {
  initial_template = {
    tag_template_id = "initial_template"
    region          = "us-central1"
    display_name    = "Basic Data Template"
    force_delete    = false
    fields = [
      {
        field_id     = "source"
        display_name = "Source of data asset"
        type = {
          primitive_type = "STRING"
        }
        is_required = true
      },
      {
        field_id     = "num_rows"
        display_name = "Number of rows in the data asset"
        type = {
          primitive_type = "DOUBLE"
        }
        is_required = false
      },
      {
        field_id     = "pii_type"
        display_name = "PII type"
        type = {
          enum_type = {
            allowed_values = [
              {
                display_name = "EMAIL"
              },
              {
                display_name = "SOCIAL SECURITY NUMBER"
              },
              {
                display_name = "NONE"
              }
            ]
          }
        }
        is_required = false
      }
    ]
  }
}

data_catalog_tags = {
  raw_data_tag = {
    template_key = "initial_template"
    fields = [
      {
        field_name   = "source"
        string_value = "customer_database"
      },
      {
        field_name   = "num_rows"
        double_value = 1000000
      },
      {
        field_name = "pii_type"
        enum_value = "EMAIL"
      }
    ]
  }

  processed_data_tag = {
    template_key = "initial_template"
    fields = [
      {
        field_name   = "source"
        string_value = "raw_data_processing"
      },
      {
        field_name   = "num_rows"
        double_value = 950000
      },
      {
        field_name = "pii_type"
        enum_value = "NONE"
      }
    ]
  }
}