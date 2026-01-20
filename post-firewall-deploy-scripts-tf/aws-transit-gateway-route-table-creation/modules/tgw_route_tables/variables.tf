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

variable "tags" {
  type = map(string)
  default = {}
}

variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "application" {
  type = string
}
