output "id" {
  value = (
    local.search ? data.aws_ami.search[0].id :
    local.select ? data.aws_ami.select[0].id :
    null
  )
}
output "name" {
  value = (
    local.search ? data.aws_ami.search[0].name :
    local.select ? data.aws_ami.select[0].name :
    null
  )
}
output "owners" {
  value = (
    local.search ? data.aws_ami.search[0].owners :
    local.select ? data.aws_ami.select[0].owners :
    null
  )
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
  value = (
    local.search ? data.aws_ami.search[0] :
    local.select ? data.aws_ami.select[0] :
    null
  )
}
output "image" {
  value = (
    local.search ?
    {
      id          = data.aws_ami.search[0].id
      user        = local.user
      admin_group = local.admin_group
      workfolder  = local.workfolder
    } :
    local.select ?
    {
      id          = data.aws_ami.select[0].id
      user        = local.user
      admin_group = local.admin_group
      workfolder  = local.workfolder
    } :
    null
  )
}
output "types" {
  value = local.types
}
