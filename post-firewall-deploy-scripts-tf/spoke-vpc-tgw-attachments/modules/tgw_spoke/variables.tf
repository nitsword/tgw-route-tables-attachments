variable "tgw_id" {}
variable "vpc_id" {}
variable "subnet_ids" { type = list(string) }
variable "tags" {
  type = map(string)
  default = {}
}

variable "region" {
  type = map(string)
}

variable "environment" {
  type = map(string)
}

variable "application" {
  type = map(string)
  default = {}
}
variable "base_tags" {
  type    = map(string)
  default = { "Created by" = "Cloud Network Team" }
}
