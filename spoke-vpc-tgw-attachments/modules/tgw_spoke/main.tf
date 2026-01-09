# modules/tgw_spoke/main.tf
variable "tgw_id" {}
variable "vpc_id" {}
variable "subnet_ids" { type = list(string) }

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  transit_gateway_id = var.tgw_id
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
}