provider "aws" {
  region = var.region
}

data "aws_ec2_transit_gateway_route_tables" "this" {
  filter {
    name   = "transit-gateway-id"
    values = [var.tgw_id]
  }
}

data "aws_ec2_transit_gateway_route_table" "by_id" {
  for_each = toset(data.aws_ec2_transit_gateway_route_tables.this.ids)

  id = each.value
}

locals {
  firewall_tgw_route_table_id = one([
    for rt in data.aws_ec2_transit_gateway_route_table.by_id :
    rt.id
    if lookup(rt.tags, "Name", "") == "firewall-rt"
  ])

  spoke_inspection_tgw_route_table_id = one([
    for rt in data.aws_ec2_transit_gateway_route_table.by_id :
    rt.id
    if lookup(rt.tags, "Name", "") == "spoke-inspection-rt"
  ])

  firewall_routes_from_csv = {
    for r in csvdecode(file("${path.module}/tgw-fw-route.csv")) :
    r.name => {
      destination_cidr_block        = trimspace(r.destination_cidr)
      transit_gateway_attachment_id = trimspace(r.attachment_id)
    }
  }

  firewall_route_cidrs = [
    for r in local.firewall_routes_from_csv :
    r.destination_cidr_block
  ]

  # All unique TGW attachment IDs from CSV
  spoke_tgw_attachment_ids = toset([
    for r in local.firewall_routes_from_csv :
    r.transit_gateway_attachment_id
  ])
}

resource "null_resource" "validate_unique_firewall_routes" {
  lifecycle {
    precondition {
      condition     = length(local.firewall_route_cidrs) == length(distinct(local.firewall_route_cidrs))
      error_message = "Duplicate destination CIDRs detected in firewall_routes.csv"
    }
  }
}

module "firewall_return_routes" {
  source = "../../../modules/tgw_routes"
  count  = var.enable_firewall_routes ? 1 : 0

  route_table_id = local.firewall_tgw_route_table_id
  routes         = local.firewall_routes_from_csv

  depends_on = [
    null_resource.validate_unique_firewall_routes
  ]
}


resource "aws_ec2_transit_gateway_route_table_association" "spoke_assoc" {
  for_each = local.spoke_tgw_attachment_ids

  transit_gateway_attachment_id  = each.value
  transit_gateway_route_table_id = local.spoke_inspection_tgw_route_table_id
  replace_existing_association = true
}