resource "aws_ec2_transit_gateway_route_table" "this" {
  for_each = var.route_tables

  transit_gateway_id = var.tgw_id

 tags = merge(
    var.tags,        
    each.value.tags,
    {
      Name = each.key
    }
  )
}
