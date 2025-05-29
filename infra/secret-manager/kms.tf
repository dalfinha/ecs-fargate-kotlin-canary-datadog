resource "aws_kms_key" "this" {
  description             = "KMS rotation - Datadog Keys"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "this" {
  name          = "alias/kms-datadog"
  target_key_id = aws_kms_key.this.key_id
}