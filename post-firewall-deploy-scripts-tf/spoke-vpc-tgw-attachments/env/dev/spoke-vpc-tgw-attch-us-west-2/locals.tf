locals {
  # Read CSV and normalize input
  spoke_vpc_attachments = [
    for r in csvdecode(file("${path.module}/spoke_vpc_subnet.csv")) : {
      account        = trimspace(r.account)
      vpc_id         = trimspace(r.vpc_id)
      subnet_ids     = [for s in split(",", r.subnet_ids) : trimspace(s)]
      route_table_id = (
        try(trimspace(r.route_table_id), "") != ""
        ? trimspace(r.route_table_id)
        : null
      )
    }
  ]

  # Group attachments by account (provider alias)
  attachments_by_account = {
    for acct in distinct([for a in local.spoke_vpc_attachments : a.account]) :
    acct => [
      for a in local.spoke_vpc_attachments :
      a if a.account == acct
    ]
  }

  # Guardrail helpers
  all_vpc_ids = [for a in local.spoke_vpc_attachments : a.vpc_id]
  all_route_table_ids = [for a in local.spoke_vpc_attachments : a.route_table_id]
}
