# 1. TGW Owner Account (Hub)
provider "aws" {
  region = "us-east-1"
}

# 2. Spoke Account 1
provider "aws" {
  alias  = "spoke_one"
  region = "us-east-1"
  assume_role {
    role_arn = ""
  }
}

# 3. Spoke Account 2
provider "aws" {
  alias  = "spoke_two"
  region = "us-east-1"
  assume_role {
    role_arn = ""
  }
}

# Transit Gateway
data "aws_ec2_transit_gateway" "main" {
  id = "tgw-09396a29da000e3c8" 
}

#  Account 1 Attachment
module "attachment_spoke1" {
  source     = "./modules/tgw_spoke"
  providers  = { aws = aws.spoke_one }
  
  tgw_id     = data.aws_ec2_transit_gateway.main.id
  vpc_id     = "vpc-11111111"
  subnet_ids = ["subnet-1a", "subnet-1b"]
}

# Account 2 Attachment
module "attachment_spoke2" {
  source     = "./modules/tgw_spoke"
  providers  = { aws = aws.spoke_two }
  
  tgw_id     = data.aws_ec2_transit_gateway.main.id
  vpc_id     = "vpc-22222222"
  subnet_ids = ["subnet-2a", "subnet-2b"]
}