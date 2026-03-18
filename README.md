# S3 Bucket Module

Creates an AWS S3 bucket with configurable name and optional tags.

## Inputs

| Name        | Type        | Description                          | Required |
|------------|------------|--------------------------------------|----------|
| bucket_name | string     | Globally unique S3 bucket name       | Yes      |
| tags        | map(string)| Tags to apply to the bucket          | No       |

## Outputs

| Name        | Description         |
|------------|---------------------|
| bucket_id   | S3 bucket ID        |
| bucket_arn  | S3 bucket ARN       |