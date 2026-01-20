variable "tgw_id" {}
variable "vpc_id" {}
variable "subnet_ids" { type = list(string) }
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
variable "base_tags" {
  type    = map(string)
  default = { "Created by" = "Cloud Network Team" }
}
