environment = "dev"
application = "ntw"
region = "us-east-1"

tgw_id = "tgw-09396a29da000e3c8"

firewall_tgw_attachment_id = "tgw-attach-089d75803205b9d92"

enable_firewall_routes = true

# Need to put desination cidrs and spoke tgw attachement ids for routes addition
firewall_routes = {
  spoke1_ipv4 = {
    destination_cidr_block        = "10.1.0.0/16"
    transit_gateway_attachment_id = "tgw-attach-08899ce73b78e76bc"
  }

  spoke1_ipv6 = {
    destination_cidr_block        = "2600:abcd:100::/56"
    transit_gateway_attachment_id = "tgw-attach-08899ce73b78e76bc"
  }

spoke2_ipv4 = {
    destination_cidr_block        = "10.2.0.0/16"
    transit_gateway_attachment_id = "tgw-attach-0f11c6fa51742a872"
  }

  spoke2_ipv6 = {
    destination_cidr_block        = "2600:abcd:200::/56"
    transit_gateway_attachment_id = "tgw-attach-0f11c6fa51742a872"
  }

spoke3_ipv4 = {
    destination_cidr_block        = "10.3.0.0/16"
    transit_gateway_attachment_id = "tgw-attach-01b20e458d305791f"
  }

  spoke3_ipv6 = {
    destination_cidr_block        = "2600:abcd:300::/56"
    transit_gateway_attachment_id = "tgw-attach-01b20e458d305791f"
  }
}

spoke_tgw_attachment_ids = {
  spoke1 ="tgw-attach-08899ce73b78e76bc"
  spoke2 ="tgw-attach-0f11c6fa51742a872"
  spoke3 ="tgw-attach-01b20e458d305791f"
}

common_tags = {
  Environment = "dev"
  Application = "ntw"
  CreatedBy       = "Cloud-network-team"
} 