provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

locals {
  create_target_group = var.target_group_arn == "" ? "true" : "false"
}

locals {
  target_group_arn = local.create_target_group == "true" ? aws_lb_target_group.default[0].arn : var.target_group_arn
}

data "aws_lb_target_group" "default" {
  arn = local.target_group_arn
}

module "label" {
  source = "github.com/mitlibraries/tf-mod-name?ref=0.12"
  name   = var.name
  tags   = var.tags
}

resource "aws_lb_target_group" "default" {
  count       = local.create_target_group == "true" ? 1 : 0
  name        = module.label.name
  port        = var.port
  protocol    = var.protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  deregistration_delay = var.deregistration_delay

  health_check {
    path                = var.health_check_path
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "paths" {
  count        = length(var.paths) > 0 && length(var.hosts) == 0 ? var.listener_arns_count : 0
  listener_arn = var.listener_arns[count.index]
  priority     = var.priority + count.index

  action {
    type             = "forward"
    target_group_arn = local.target_group_arn
  }

  condition {
    field  = "path-pattern"
    values = var.paths
  }
}

resource "aws_lb_listener_rule" "hosts" {
  count        = length(var.hosts) > 0 && length(var.paths) == 0 ? var.listener_arns_count : 0
  listener_arn = var.listener_arns[count.index]
  priority     = var.priority + count.index

  action {
    type             = "forward"
    target_group_arn = local.target_group_arn
  }

  condition {
    field  = "host-header"
    values = var.hosts
  }
}

resource "aws_lb_listener_rule" "hosts_paths" {
  count        = length(var.paths) > 0 && length(var.hosts) > 0 ? var.listener_arns_count : 0
  listener_arn = var.listener_arns[count.index]
  priority     = var.priority + count.index

  action {
    type             = "forward"
    target_group_arn = local.target_group_arn
  }

  condition {
    field  = "host-header"
    values = var.hosts
  }

  condition {
    field  = "path-pattern"
    values = var.paths
  }
}

