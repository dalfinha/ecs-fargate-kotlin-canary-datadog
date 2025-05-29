resource "aws_secretsmanager_secret" "this" {
  name = "datadog-config-keys"
  kms_key_id = aws_kms_key.this.arn
}