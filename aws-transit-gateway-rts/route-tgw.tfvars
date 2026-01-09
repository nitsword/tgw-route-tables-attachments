environment = "dev"
application = "ntw"

tgw_id = "tgw-09396a29da000e3c8"

firewall_tgw_attachment_id = "tgw-attach-0d41d51f873376fe3"

enable_firewall_routes = false
firewall_routes        = {}

# firewall_routes = {
#   spoke1_ipv4 = {
#     destination_cidr_block        = "10.1.0.0/16"
#     transit_gateway_attachment_id = "tgw-attach-01111"
#   }

#   spoke1_ipv6 = {
#     destination_cidr_block        = "2600:abcd:100::/56"
#     transit_gateway_attachment_id = "tgw-attach-01111"
#   }
# }

spoke_tgw_attachment_ids = {}

common_tags = {
  Environment = "dev"
  Application = "ntw"
  CreatedBy       = "Cloud-network-team"
} 