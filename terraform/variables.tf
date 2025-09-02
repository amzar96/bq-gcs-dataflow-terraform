variable "environment" {
    type = string
    default = "development"
}

variable "tags" {
  type = map(string)
  default = {
    Project = "default value"
    Owner = "data engineer"
    Email = "data-engineer@abc.com"
  }
}

variable "project" {
  type = string
  default = "default-project"
}

variable "bq_datasets" {
  type = map(object({
    dataset_id                  = string
    friendly_name              = string
    description                = string
    location                   = string
    default_table_expiration_ms = number
    labels                     = map(string)
    access_rules = list(object({
      role          = string
      user_by_email = optional(string)
      domain        = optional(string)
      dataset_access = optional(object({
        project_id   = string
        dataset_id   = string
        target_types = list(string)
      }))
    }))
  }))
  default = {}
}

variable "service_accounts" {
  type = map(object({
    account_id   = string
    display_name = optional(string)
  }))
  default = {}
}

variable "project_id" {
  type        = string
}

variable "gcs_buckets" {
  type = map(object({
    name          = string
    location      = string
    storage_class = string
    versioning_enabled = optional(bool, false)
    lifecycle_rules = optional(list(object({
      action = object({
        type          = string
        storage_class = optional(string)
      })
      condition = object({
        age                   = optional(number)
        created_before        = optional(string)
        with_state           = optional(string)
        matches_storage_class = optional(list(string))
        num_newer_versions   = optional(number)
      })
    })), [])
    labels = optional(map(string), {})
    force_destroy = optional(bool, false)
    uniform_bucket_level_access = optional(bool, true)
    public_access_prevention = optional(string, "enforced")
  }))
  default = {}
}

variable "data_catalog_tag_templates" {
  description = "Map of Data Catalog tag template configurations"
  type = map(object({
    tag_template_id = string
    region          = string
    display_name    = string
    force_delete    = optional(bool, false)
    fields = list(object({
      field_id     = string
      display_name = string
      type = object({
        primitive_type = optional(string)
        enum_type = optional(object({
          allowed_values = list(object({
            display_name = string
          }))
        }))
      })
      is_required = optional(bool, false)
    }))
  }))
  default = {}
}

variable "data_catalog_tags" {
  description = "Map of Data Catalog tag configurations"
  type = map(object({
    parent       = string
    template_key = string
    fields = list(object({
      field_name    = string
      string_value  = optional(string)
      double_value  = optional(number)
      bool_value    = optional(bool)
      enum_value    = optional(string)
    }))
  }))
  default = {}
}