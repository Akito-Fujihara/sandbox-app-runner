data "aws_route53_zone" "main" {
  name         = var.domain
  private_zone = false
}

resource "aws_route53_record" "app_runner" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = aws_apprunner_custom_domain_association.app_runner.domain_name
  type    = "CNAME"
  ttl     = "300"
  records = [aws_apprunner_custom_domain_association.app_runner.dns_target]
}

resource "aws_route53_record" "certification-validation" {
  for_each      = {
    for record in aws_apprunner_custom_domain_association.app_runner.certificate_validation_records : record.name => {
      name   = record.name
      record = record.value
    }
  }

  zone_id = data.aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = "CNAME"
  ttl     = "300"
  records = [each.value.record]
}
