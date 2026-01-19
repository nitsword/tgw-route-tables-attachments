output "route_table_ids" {
  description = "Transit Gateway route table IDs"
  value = {
    for k, v in aws_ec2_transit_gateway_route_table.this :
    k => v.id
  }
}
