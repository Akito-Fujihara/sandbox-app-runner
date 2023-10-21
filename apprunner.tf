resource "aws_apprunner_vpc_connector" "app_runner" {
  vpc_connector_name = "${var.name}-vpcconnector"
  subnets            = module.vpc.private_subnets
  security_groups    = [aws_security_group.app_runner.id]
}
