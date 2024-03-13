
output "id" {
  value = (local.search ? data.aws_ami.search[0].id : data.aws_ami.select[0].id)
}
output "ami" {
  value = (local.search ? data.aws_ami.search[0].id : data.aws_ami.select[0].id)
}
output "name" {
  value = (local.search ? data.aws_ami.search[0].name : data.aws_ami.select[0].name)
}
output "owners" {
  value = (local.search ? data.aws_ami.search[0].owners : data.aws_ami.select[0].owners)
}
output "initial_user" {
  value = local.initial_user
}
output "admin_group" {
  value = local.admin_group
}
output "workfolder" {
  value = local.workfolder
}
output "full" {
  value = data.aws_ami.search[0]
}
