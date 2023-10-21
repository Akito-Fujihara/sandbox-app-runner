resource "aws_iam_role" "app_runner" {
  name                = "${var.name}-role"
  assume_role_policy  = data.aws_iam_policy_document.app_runner.json
}

data "aws_iam_policy_document" "app_runner" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type  = "Service"
      identifiers = ["build.apprunner.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "app_runner" {
  role       = aws_iam_role.app_runner.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}
