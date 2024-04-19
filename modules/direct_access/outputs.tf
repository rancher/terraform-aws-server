output "eip" {
  value = (length(aws_eip.created) > 0 ? {
      id            = aws_eip.created[0].id
      public_ip     = aws_eip.created[0].public_ip
      allocation_id = aws_eip.created[0].allocation_id
    } : {
      id = ""
      public_ip = ""
      allocation_id = ""
    }
  )
}

output "domain" {
  value = (length(aws_route53_record.created) > 0 ? {
      id      = aws_route53_record.created[0].id
      name    = aws_route53_record.created[0].name
      fqdn    = aws_route53_record.created[0].fqdn
      records =  aws_route53_record.created[0].records
      zone_id = aws_route53_record.created[0].zone_id
    } : {
      id      = ""
      name    = ""
      fqdn    = ""
      records = toset([""])
      zone_id = ""
    }
  )
}

output "security_group" {
  value = aws_security_group.direct_access
}
