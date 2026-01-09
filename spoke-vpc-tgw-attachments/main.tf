# 1. TGW Owner Account (Hub)
provider "aws" {
  region = "us-east-1"
  alias = "primary"
}

# 2. Spoke Account 1
provider "aws" {
  alias  = "spoke_one"
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::336713654540:role/admin-role"
  }
}

# Transit Gateway
data "aws_ec2_transit_gateway" "main" {
  provider = aws.primary
  id = "tgw-09396a29da000e3c8" 
}

# resource "aws_ram_resource_share_accepter" "tgw_share_accept" {
#   provider  = aws.spoke_one
#   share_arn = var.tgw_ram_share_arn
# }

#  Account 1 Attachment
module "attachment_spoke1" {
  source     = "./modules/tgw_spoke"
  providers  = { aws = aws.spoke_one }
  
  # depends_on = [
  #   aws_ram_resource_share_accepter.tgw_share_accept
  # ]

  tgw_id     = data.aws_ec2_transit_gateway.main.id
  vpc_id     = "vpc-023792f91d16d1484"
  subnet_ids = ["subnet-0572c57fb7d9ced43", "subnet-000a17d8320f9e3bf"]
}

# # Account 2 Attachment
