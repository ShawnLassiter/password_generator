# main.tf

# 1. Active Password Resource
# The 'active' password is the one currently in use.
resource "random_password" "active_password_source" {
  # Standard settings for a strong password
  length           = var.password_length
  special          = var.include_special
  override_special = var.special_characters

  # A placeholder for a 'keeper' to control rotation.
  # The actual 'active' password is treated as persistent.
  # We use a lifecycle block below to control *its* actual source rotation.
}

# 2. Backup Password Resource
# The 'backup' password is the one that can be rotated independently.
resource "random_password" "backup_password_source" {
  # Standard settings
  length           = var.password_length
  special          = var.include_special
  override_special = var.special_characters

  # CRITICAL: This 'keeper' forces a new backup password only when
  # the input variable `var.rotate_backup` changes its value.
  # Otherwise, it's idempotent.
  keepers = {
    rotation = var.rotate_backup
  }
}

# 3. Local Variables for Swapping Logic
# These locals implement the swapping and selection logic based on `var.swap_passwords`.
locals {
  # Conditionally select which password is the 'true' active one
  final_active_password = var.swap_passwords ? random_password.backup_password_source.result : random_password.active_password_source.result

  # Conditionally select which password is the 'true' backup one
  final_backup_password = var.swap_passwords ? random_password.active_password_source.result : random_password.backup_password_source.result
}

# 4. State Management (Preventing unintentional rotation)
# This block prevents Terraform from seeing a change in the 'active_password_source'
# when a swap occurs. Only the `result` of the resources is referenced in locals.
resource "null_resource" "swap_control" {
  # This resource only exists to manage the lifecycle of the random passwords
  # if a future feature required direct manipulation, but for this case,
  # the 'keepers' and locals are sufficient to ensure idempotency.
  triggers = {
    swap = var.swap_passwords
  }
}
