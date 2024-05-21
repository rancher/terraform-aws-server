output "eip" {
  value = {
    id            = try(aws_eip.created[0].id, "")
    public_ip     = try(aws_eip.created[0].public_ip, "")
    allocation_id = try(aws_eip.created[0].allocation_id, "")
  }
}

output "domain" {
  value = {
    id      = try(aws_route53_record.created[0].id, "")
    name    = try(aws_route53_record.created[0].name, "")
    fqdn    = try(aws_route53_record.created[0].fqdn, "")
    records = try(aws_route53_record.created[0].records, toset([]))
    zone_id = try(aws_route53_record.created[0].zone_id, "")
  }
}

output "security_group" {
  value = aws_security_group.direct_access
}
