# S3 Bucket Module

Creates an AWS S3 bucket with configurable name and optional tags.

## Inputs

| Name               | Type        | Description                              | Required |
|--------------------|--------------|--------------------------------------------|----------|
| bucket_name        | string       | Globally unique S3 bucket name             | Yes      |
| tags               | map(string)  | Tags to apply to the bucket                | No       |
| enable_versioning  | bool         | Enable versioning                          | No       |
| enable_encryption  | bool         | Enable SSE-S3 encryption                   | No       |
| lifecycle_rules    | list(object) | Lifecycle transition rules-cost optimization | No |
| enable_kms_encryption | bool   | Enable KMS encryption instead of SSE-S3 | No |
| kms_key_arn           | string | KMS Key ARN for encryption              | No |

## Outputs

| Name        | Description         |
|------------|---------------------|
| bucket_id   | S3 bucket ID        |
| bucket_arn  | S3 bucket ARN       |