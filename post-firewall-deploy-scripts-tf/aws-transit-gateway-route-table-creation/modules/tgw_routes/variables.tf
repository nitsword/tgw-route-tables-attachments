variable "route_table_id" {
  description = "Transit Gateway route table ID"
  type        = string
}

variable "routes" {
  description = "Map of TGW routes to create"
  type = map(object({
    destination_cidr_block        = string
    transit_gateway_attachment_id = string
    blackhole                     = optional(bool, false)
  }))
}
