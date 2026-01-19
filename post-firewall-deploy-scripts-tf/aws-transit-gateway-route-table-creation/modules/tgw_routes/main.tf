resource "aws_ec2_transit_gateway_route" "this" {
  for_each = var.routes

  transit_gateway_route_table_id = var.route_table_id
  destination_cidr_block         = each.value.destination_cidr_block

  transit_gateway_attachment_id = (
    each.value.blackhole == true
    ? null
    : each.value.transit_gateway_attachment_id
  )

  blackhole = each.value.blackhole
}
