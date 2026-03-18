variable "bucket_name" {
  description = "Name of the S3 bucket (must be globally unique)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)
  default     = {}
}
variable "enable_versioning" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Enable server-side encryption (SSE-S3)"
  type        = bool
  default     = true
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules for the S3 bucket"
  type = list(object({
    id              = string
    enabled         = bool
    transition_days = number
    storage_class   = string
  }))
}

variable "enable_kms_encryption" {
  description = "Enable KMS-based encryption"
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "KMS Key ARN for encryption (required if enable_kms_encryption is true)"
  type        = string
  default     = null

  validation {
    condition     = var.enable_kms_encryption == false || (var.kms_key_arn != null && length(var.kms_key_arn) > 0)
    error_message = "kms_key_arn must be provided when enable_kms_encryption is true."
  }
}