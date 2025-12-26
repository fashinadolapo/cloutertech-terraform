locals {
  # Naming convention
  name_prefix = "${var.application_name}-${var.environment}"

  # Merged tags for all resources
  common_tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      Application = var.application_name
      CreatedAt   = timestamp()
    }
  )
}
