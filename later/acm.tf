resource "aws_acm_certificate" "k8s-lb-https" {
  provider          = aws.region
  domain_name       = join(".", ["k8s", data.aws_route53_zone.dns.name])
  validation_method = "DNS"
  tags = {
    Name = "k8s-ACM"
  }
}

#Validates ACM issued certificate via Route53
resource "aws_acm_certificate_validation" "cert" {
  provider                = aws.region
  certificate_arn         = aws_acm_certificate.k8s-lb-https.arn
  for_each                = aws_route53_record.cert_validation
  validation_record_fqdns = [aws_route53_record.cert_validation[each.key].fqdn]
}