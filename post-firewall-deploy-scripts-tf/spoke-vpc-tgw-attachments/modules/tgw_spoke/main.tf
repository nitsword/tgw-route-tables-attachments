# modules/tgw_spoke/main.tf
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  transit_gateway_id = var.tgw_id
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids

  ipv6_support           = "disable"
  dns_support            = "enable"
  appliance_mode_support = "enable"

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
}