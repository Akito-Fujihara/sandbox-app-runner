resource "aws_apprunner_vpc_connector" "app_runner" {
  vpc_connector_name = "${var.name}-vpcconnector"
  subnets            = module.vpc.private_subnets
  security_groups    = [aws_security_group.app_runner.id]
}

resource "aws_apprunner_service" "main" {
  service_name = "${var.name}-service"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.app_runner.arn
    }

    image_repository {
      image_configuration {
        port                          = 80
        runtime_environment_variables = {}
      }
      image_identifier      = "${aws_ecr_repository.main.repository_url}:latest"
      image_repository_type = "ECR"
    }
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.app_runner.arn
    }
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.app_runner.arn
}

resource "aws_apprunner_auto_scaling_configuration_version" "app_runner" {
  auto_scaling_configuration_name = "${var.name}-autoscaling"

  max_concurrency = 70
  max_size        = 3
  min_size        = 1
}
