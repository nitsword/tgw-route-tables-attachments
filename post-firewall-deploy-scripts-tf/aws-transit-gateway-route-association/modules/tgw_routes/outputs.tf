output "routes" {
  description = "Created TGW routes"
  value = {
    for k, v in aws_ec2_transit_gateway_route.this :
    k => {
      id        = v.id
      cidr      = v.destination_cidr_block
      blackhole = v.blackhole
    }
  }
}
