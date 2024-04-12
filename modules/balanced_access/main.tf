locals {
  name   = var.name
  ports  = var.ports
  server = var.server
}

data "aws_lb" "general_info" {
  tags = {
    Name = local.name
  }
}

data "aws_subnet" "general_info" {
  id = element(data.aws_lb.general_info.subnets, 0)
}

resource "aws_lb_target_group" "server" {
  for_each = toset(local.ports)
  depends_on = [
    data.aws_lb.general_info,
    data.aws_subnet.general_info,
  ]
  name_prefix = "${local.name}-${each.key}-"
  port        = each.key
  vpc_id      = data.aws_subnet.general_info.vpc_id
  protocol    = "TCP"
  target_type = "instance"
  tags = {
    Name = "${local.name}-${each.key}"
  }
}

resource "aws_lb_target_group_attachment" "server" {
  for_each = toset(local.ports)
  depends_on = [
    data.aws_subnet.general_info,
    data.aws_lb.general_info,
    aws_lb_target_group.server,
  ]
  target_group_arn = aws_lb_target_group.server[each.key].arn
  target_id        = local.server.id
  port             = each.key
}

resource "aws_lb_listener" "server" {
  for_each = toset(local.ports)
  depends_on = [
    data.aws_subnet.general_info,
    data.aws_lb.general_info,
    aws_lb_target_group.server,
  ]
  load_balancer_arn = data.aws_lb.general_info.arn
  port              = each.key
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.server[each.key].arn
  }
}
