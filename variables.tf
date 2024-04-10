variable "user_uuid" {
  description = "User UUID"
  type        = string
  validation {
    condition = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.user_uuid))
    error_message = "User UUID must be a valid UUID format (e.g., 123e4567-e89b-12d3-a456-426655440000)"
  }
}


variable "bucket_name" {
  description = "Name of the AWS S3 bucket"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9.-]{3,63}$", var.bucket_name))
    error_message = "Bucket name must be between 3 and 63 characters long and can only contain letters, numbers, hyphens, and periods"
  }
}
