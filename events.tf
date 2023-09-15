data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

locals {
  region_name  = data.aws_region.current.name
  account_id   = data.aws_caller_identity.current.account_id
  cluster_name = aws_ecs_cluster.the_cluster.name
}

resource "aws_cloudwatch_event_rule" "ecs_task_stopped" {
  name        = "${local.cluster_name}-task-stopped"
  description = "Task stopped"

  event_pattern = jsonencode({
    detail-type = ["ECS Task State Change"]
    source      = ["aws.ecs"]
    resources   = [
      {
        prefix = "arn:aws:ecs:${local.region_name}:${local.account_id}:task/${local.cluster_name}/"
      }
    ]
    detail = {
      desiredStatus = ["STOPPED"]
      lastStatus    = ["STOPPED"]
    }
  })
}

resource "aws_cloudwatch_log_group" "ecs_stopped_tasks" {
  name              = "/aws/events/${var.stopped_ecs_task_log_group}"
  retention_in_days = var.stopped_ecs_task_log_retention_days
}

resource "aws_cloudwatch_event_target" "log_ecs_task_stopped" {
  rule = aws_cloudwatch_event_rule.ecs_task_stopped.name
  arn  = aws_cloudwatch_log_group.ecs_stopped_tasks.arn
}

data "aws_iam_policy_document" "ecs_stopped_tasks_log_group_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream"
    ]

    resources = [
      aws_cloudwatch_log_group.ecs_stopped_tasks.arn,
      "${aws_cloudwatch_log_group.ecs_stopped_tasks.arn}:*"
    ]

    principals {
      type        = "Service"
      identifiers = [
        "events.amazonaws.com",
        "delivery.logs.amazonaws.com"
      ]
    }
  }
  statement {
    effect  = "Allow"
    actions = [
      "logs:PutLogEvents"
    ]

    resources = [
      aws_cloudwatch_log_group.ecs_stopped_tasks.arn,
      "${aws_cloudwatch_log_group.ecs_stopped_tasks.arn}:*",
      "${aws_cloudwatch_log_group.ecs_stopped_tasks.arn}:*:*"
    ]

    principals {
      type        = "Service"
      identifiers = [
        "events.amazonaws.com",
        "delivery.logs.amazonaws.com"
      ]
    }

    condition {
      test     = "ArnEquals"
      values   = [
        aws_cloudwatch_log_group.ecs_stopped_tasks.arn
      ]
      variable = "aws:SourceArn"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "ecs_stopped_tasks" {
  policy_document = data.aws_iam_policy_document.ecs_stopped_tasks_log_group_policy.json
  policy_name     = "ecs-stopped-tasks-log-publishing-policy"
}
