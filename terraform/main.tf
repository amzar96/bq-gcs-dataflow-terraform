terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

locals {
  env          = var.environment
  project_name = join("-", [var.environment, var.project])
}

module "gcs_buckets" {
  source = "./modules/gcs_buckets"

  buckets    = var.gcs_buckets
  project_id = var.project_id
}

module "bigquery_dataset" {
  source = "./modules/bigquery_dataset"

  datasets         = var.bq_datasets
  service_accounts = var.service_accounts
}

module "data_catalog" {
  source = "./modules/data_catalog"

  tag_templates = var.data_catalog_tag_templates
  tags          = var.data_catalog_tags
}