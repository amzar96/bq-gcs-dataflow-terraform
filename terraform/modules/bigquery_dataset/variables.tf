variable "datasets" {
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
}

variable "service_accounts" {
  type = map(object({
    account_id   = string
    display_name = optional(string)
  }))
  default = {}
}