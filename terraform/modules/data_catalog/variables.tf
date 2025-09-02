variable "tag_templates" {
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

variable "tags" {
  type = map(object({
    parent   = string
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