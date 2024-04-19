locals {
  server_id     = var.server_id
  target_groups = var.target_group_names
}

data "aws_lb_target_group" "general_info" {
  for_each = toset(local.target_groups)
  tags = {
    Name = each.key
  }
}

resource "aws_lb_target_group_attachment" "server" {
  for_each = toset(local.target_groups)
  depends_on = [
    data.aws_lb_target_group.general_info,
  ]
  target_group_arn = data.aws_lb_target_group.general_info[each.key].arn
  target_id        = local.server_id
}
