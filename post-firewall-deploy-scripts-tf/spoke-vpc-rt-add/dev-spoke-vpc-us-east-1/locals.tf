locals {
  # Read CSV and normalize input
  spoke_vpc_rts = [
    for r in csvdecode(file("${path.module}/spoke_vpc_rts.csv")) : {
      account        = trimspace(r.account)
      vpc_id         = trimspace(r.vpc_id)
      route_table_id = trimspace(r.route_table_id)
      destination_cidr = (
        try(trimspace(r.destination_cidr), "") != ""
        ? trimspace(r.destination_cidr)
        : null
      )
    }
  ]

    # Group attachments by account (provider alias)
  attachments_by_account = {
    for acct in distinct([for a in local.spoke_vpc_rts : a.account]) :
    acct => [
      for a in local.spoke_vpc_rts :
      a if a.account == acct
    ]
  }

  all_vpc_ids = [for a in local.spoke_vpc_rts : a.vpc_id]
  all_route_table_ids = [for a in local.spoke_vpc_rts : a.route_table_id]
}
