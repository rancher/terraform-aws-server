output "eip" {
  value = aws_eip.created[0]
}

output "domain" {
  value = aws_route53_record.created[0]
}

output "security_group" {
  value = aws_security_group.direct_access
}
