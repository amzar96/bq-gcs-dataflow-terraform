variable "buckets" {
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

variable "project_id" {
  type        = string
}