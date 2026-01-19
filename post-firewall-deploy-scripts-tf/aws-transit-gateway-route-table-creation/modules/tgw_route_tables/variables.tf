variable "tgw_id" {
  description = "Transit Gateway ID"
  type        = string
}

variable "route_tables" {
  description = "Transit Gateway route tables to create"
  type = map(object({
    tags = map(string)
  }))
}

variable "common_tags" {
  description = "Tags applied to all route tables"
  type        = map(string)
  default     = {}
}
