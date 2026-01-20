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
      error_message = "Duplicate VPC IDs detected. A VPC can only have one TGW attachment."
    }
  }
}

# Transit Gateway
data "aws_ec2_transit_gateway" "main" {
  provider = aws.primary
  id       = var.tgw_id
}

################################
###   Primary Account vpc    ###
################################

module "attachments_primary" {
  source    = "../../../modules/tgw_spoke"
  providers = { aws = aws.primary }
  application          = var.application
  region               = var.region
  environment = var.environment
  base_tags            = var.base_tags

  for_each = {
    for i, a in lookup(local.attachments_by_account, "primary", []) :
    "${a.vpc_id}-${i}" => a
  }

  tgw_id     = var.tgw_id
  vpc_id     = each.value.vpc_id
  subnet_ids = each.value.subnet_ids

  tags = merge(
    var.base_tags,
    {}
  )
}

resource "aws_route" "primary_default_to_tgw" {
  provider = aws.primary

  for_each = {
    for i, a in lookup(local.attachments_by_account, "primary", []) :
    "${a.route_table_id}-${i}" => a
    if a.route_table_id != null
  }

  route_table_id         = each.value.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.tgw_id

  depends_on = [
    module.attachments_primary
  ]
}

################################
###     Spoke vpc 1          ###
################################

module "attachments_spoke_one" {
  source    = "../../../modules/tgw_spoke"
  providers = { aws = aws.spoke_one }
  application          = var.application
  region               = var.region
  environment = var.environment
  base_tags            = var.base_tags

  for_each = {
    for i, a in lookup(local.attachments_by_account, "spoke_one", []) :
    "${a.vpc_id}-${i}" => a
  }

  tgw_id     = var.tgw_id
  vpc_id     = each.value.vpc_id
  subnet_ids = each.value.subnet_ids

    tags = merge(
    var.base_tags,
    {}
  )
}

resource "aws_route" "spoke_one_default_to_tgw" {
  provider = aws.spoke_one

  for_each = {
    for i, a in lookup(local.attachments_by_account, "spoke_one", []) :
    "${a.route_table_id}-${i}" => a
    if a.route_table_id != null
  }

  route_table_id         = each.value.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.tgw_id

  depends_on = [
    module.attachments_spoke_one
  ]
}

################################
###     Spoke vpc 2          ###
################################

# module "attachments_spoke_two" {
#   source    = "../../../modules/tgw_spoke"
#   providers = { aws = aws.spoke_two }
#  application          = var.application
#   region               = var.region
#   environment = var.environment
#   base_tags            = var.base_tags

#   for_each = {
#     for i, a in lookup(local.attachments_by_account, "spoke_two", []) :
#     "${a.vpc_id}-${i}" => a
#   }

#   tgw_id     = var.tgw_id
#   vpc_id     = each.value.vpc_id
#   subnet_ids = each.value.subnet_ids

#  tags = merge(
#     var.base_tags,
#     {}
#   )
# }

# resource "aws_route" "spoke_two_default_to_tgw" {
#   provider = aws.spoke_two

#   for_each = {
#     for i, a in lookup(local.attachments_by_account, "spoke_two", []) :
#     "${a.route_table_id}-${i}" => a
#     if a.route_table_id != null
#   }

#   route_table_id         = each.value.route_table_id
#   destination_cidr_block = "0.0.0.0/0"
#   transit_gateway_id     = var.tgw_id

#   depends_on = [
#     module.attachments_spoke_two
#   ]
# }

