# ==============================================================================
# analytics-service: consome SQS + grava no DynamoDB
# ==============================================================================
data "aws_iam_policy_document" "analytics_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_issuer_url}:sub"
      values   = ["system:serviceaccount:${var.analytics_namespace}:${var.analytics_service_account}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_issuer_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "analytics_permissions" {
  statement {
    sid    = "DynamoDBWrite"
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:DescribeTable",
    ]
    resources = [
      var.dynamodb_table_arn,
      "${var.dynamodb_table_arn}/index/*",
    ]
  }

  statement {
    sid    = "SQSConsume"
    effect = "Allow"
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
    ]
    resources = [var.sqs_queue_arn]
  }
}

resource "aws_iam_role" "analytics" {
  name               = "${var.name_prefix}-analytics-irsa"
  assume_role_policy = data.aws_iam_policy_document.analytics_assume.json

  tags = {
    Name = "${var.name_prefix}-analytics-irsa"
  }
}

resource "aws_iam_policy" "analytics" {
  name   = "${var.name_prefix}-analytics-policy"
  policy = data.aws_iam_policy_document.analytics_permissions.json
}

resource "aws_iam_role_policy_attachment" "analytics" {
  role       = aws_iam_role.analytics.name
  policy_arn = aws_iam_policy.analytics.arn
}

# ==============================================================================
# evaluation-service: publica eventos no SQS
# ==============================================================================
data "aws_iam_policy_document" "evaluation_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_issuer_url}:sub"
      values   = ["system:serviceaccount:${var.evaluation_namespace}:${var.evaluation_service_account}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_issuer_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "evaluation_permissions" {
  statement {
    sid    = "SQSPublish"
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
    ]
    resources = [var.sqs_queue_arn]
  }
}

resource "aws_iam_role" "evaluation" {
  name               = "${var.name_prefix}-evaluation-irsa"
  assume_role_policy = data.aws_iam_policy_document.evaluation_assume.json

  tags = {
    Name = "${var.name_prefix}-evaluation-irsa"
  }
}

resource "aws_iam_policy" "evaluation" {
  name   = "${var.name_prefix}-evaluation-policy"
  policy = data.aws_iam_policy_document.evaluation_permissions.json
}

resource "aws_iam_role_policy_attachment" "evaluation" {
  role       = aws_iam_role.evaluation.name
  policy_arn = aws_iam_policy.evaluation.arn
}
