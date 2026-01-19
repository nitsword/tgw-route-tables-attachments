# 1. TGW Owner Account (Hub)
provider "aws" {
  region = "us-east-1"
  alias  = "primary"
}

# 2. Spoke Account 1
provider "aws" {
  alias  = "spoke_one"
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::336713654540:role/admin-role"
  }
}

# provider "aws" {
#   alias  = "spoke_two"
#   region = "us-east-1"
#   assume_role {
#     role_arn = "arn:aws:iam::336713654540:role/admin-role"
#   }
# }

resource "null_resource" "validate_unique_vpcs" {
  lifecycle {
    precondition {
      condition     = length(local.all_vpc_ids) == length(distinct(local.all_vpc_ids))
      error_message = "Duplicate VPC IDs detected."
    }
  }
}


################################
###   primary Account vpc    ###
################################ 

resource "aws_route" "primary_default_to_tgw" {
  provider = aws.primary

  for_each = {
    for i, a in lookup(local.attachments_by_account, "primary", []) :
    "${a.route_table_id}-${i}" => a
  }

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.destination_cidr
  transit_gateway_id     = var.tgw_id

}

################################
###   spoke 1 Account vpc    ###
################################    

resource "aws_route" "spoke_one_default_to_tgw" {
  provider = aws.spoke_one

  for_each = {
    for i, a in lookup(local.attachments_by_account, "spoke_one", []) :
    "${a.route_table_id}-${i}" => a
  }

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.destination_cidr
  transit_gateway_id     = var.tgw_id

}

################################
###   spoke 2 Account vpc    ###
################################    

# resource "aws_route" "spoke_two_default_to_tgw" {
#   provider = aws.spoke_two

#   for_each = {            
#     for i, a in lookup(local.attachments_by_account, "spoke_two", []) :
#     "${a.route_table_id}-${i}" => a
#   }

#   route_table_id         = each.value.route_table_id
#   destination_cidr_block = each.value.destination_cidr
#   transit_gateway_id     = var.tgw_id

# } 