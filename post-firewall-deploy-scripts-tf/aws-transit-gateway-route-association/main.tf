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
}



module "firewall_return_routes" {
  source = "./modules/tgw_routes"
  count  = var.enable_firewall_routes ? 1 : 0

  route_table_id = local.firewall_tgw_route_table_id
  routes         = var.firewall_routes
}


resource "aws_ec2_transit_gateway_route_table_association" "spoke_assoc" {
  for_each = var.spoke_tgw_attachment_ids

  transit_gateway_attachment_id  = each.value
  transit_gateway_route_table_id = local.spoke_inspection_tgw_route_table_id
  replace_existing_association = true
}