variable "spoke_tgw_attachment_ids" {
  description = "Map of spoke VPC TGW attachment IDs"
  type        = map(string)
  default     = {}
}

variable "firewall_tgw_attachment_id" {
  description = "TGW attachment ID for Firewall VPC"
  type        = string
}


variable "tgw_id" {
  description = "Existing Transit Gateway ID"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}

variable "application" { type = string }
variable "environment" { type = string }
#variable "env" { type = string }

variable "base_tags" {
  type    = map(string)
  default = { "Created by" = "Cloud Network Team" }
}

variable "enable_firewall_routes" {
  description = "Whether to create routes in firewall TGW route table"
  type        = bool
  default     = false
}

variable "firewall_routes" {
  description = "TGW routes for the firewall route table (optional)"
  type = map(object({
    destination_cidr_block        = string
    transit_gateway_attachment_id = string
    blackhole                     = optional(bool, false)
  }))
  default = {}

  validation {
    condition     = var.enable_firewall_routes == false || length(var.firewall_routes) > 0
    error_message = "firewall_routes must be defined when enable_firewall_routes is true."
  }
}
