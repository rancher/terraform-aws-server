output "id" {
  value = (local.search ? data.aws_ami.search[0].id : data.aws_ami.select[0].id)
}
output "name" {
  value = (local.search ? data.aws_ami.search[0].name : data.aws_ami.select[0].name)
}
output "owners" {
  value = (local.search ? data.aws_ami.search[0].owners : data.aws_ami.select[0].owners)
}
output "user" {
  value = local.user
}
output "admin_group" {
  value = local.admin_group
}
output "workfolder" {
  value = local.workfolder
}
output "ami" {
  value = (local.search ? data.aws_ami.search[0] : data.aws_ami.select[0])
}
output "image" {
  value = (local.search ? {
    id          = data.aws_ami.search[0].id
    user        = local.user
    admin_group = local.admin_group
    workfolder  = local.workfolder
    } : {
    id          = data.aws_ami.select[0].id
    user        = local.user
    admin_group = local.admin_group
    workfolder  = local.workfolder
  })
}
