module "tgw_route_tables" {
  source = "./modules/tgw_route_tables"

  tgw_id = var.tgw_id

  common_tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }

  route_tables = {
    spoke-inspection-rt = {
      tags = {
        Purpose = "spoke-to-firewall"
      }
    }

    firewall-rt = {
      tags = {
        Purpose = "firewall-routing"
      }
    }
  }
}

module "spoke_inspection_routes" {
  source = "./modules/tgw_routes"

  route_table_id = module.tgw_route_tables.route_table_ids["spoke-inspection-rt"]

  routes = {
    default_to_firewall = {
      destination_cidr_block        = "0.0.0.0/0"
      transit_gateway_attachment_id = var.firewall_tgw_attachment_id
    }

    ipv6_to_firewall = {
      destination_cidr_block        = "::/0"
      transit_gateway_attachment_id = var.firewall_tgw_attachment_id
    }
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "firewall_assoc" {
  transit_gateway_attachment_id  = var.firewall_tgw_attachment_id
  transit_gateway_route_table_id = module.tgw_route_tables.route_table_ids["firewall-rt"]
}
