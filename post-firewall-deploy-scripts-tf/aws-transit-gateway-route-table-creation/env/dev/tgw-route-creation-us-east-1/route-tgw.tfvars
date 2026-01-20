environment = "dev"
application = "ntw"
region = "us-east-1"

tgw_id = "tgw-0c61971f6a5e960d9"

firewall_tgw_attachment_id = "tgw-attach-0e4d12f6f9c635fa4"

enable_firewall_routes = false
# firewall_routes        = {}

# firewall_routes = {
#   spoke1_ipv4 = {
#     destination_cidr_block        = "10.1.0.0/16"
#     transit_gateway_attachment_id = "tgw-attach-0b6084ba670f4b793"
#   }
# }

#   spoke1_ipv6 = {
#     destination_cidr_block        = "2600:abcd:100::/56"
#     transit_gateway_attachment_id = "tgw-attach-01111"
#   }
# }

# spoke_tgw_attachment_ids = {
#   spoke1 ="tgw-attach-0b6084ba670f4b793"
# }
