# variable "tgw_ram_share_arn" {
#   description = "RAM share ARN for the Transit Gateway from hub account"
#   type        = string
# }

variable "tgw_id" {
  description = "Transit Gateway ID"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}

variable "application" { 
  type = string
  }
variable "environment" { 
  type = string
  }
variable "region" {
  type = string
}

variable "base_tags" {
  type    = map(string)
  default = { "Created by" = "Cloud Network Team" }
}
