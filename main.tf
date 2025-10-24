# root/main.tf

# Configure the random provider
terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

variable "rotate" {
    description = "rotate passwords"
    type        = bool
}

# 1. Initial State (Idempotent)
module "passwords_initial" {
  source = "./modules/password_generator"
}


# 2. Rotation Example (Backup Password Rotated)
# This uses a timestamp to force rotation on demand.
module "passwords_rotated" {
  source = "./modules/password_generator"

  # Setting rotate_backup to a new value forces the backup password to regenerate
  rotate_backup = "rotation-2025-10-24"
}

# 3. Swapping Example
# This keeps the initial passwords, but swaps their designations.
module "passwords_swapped" {
  source = "./modules/password_generator"

  # Set to true to make the old backup password the new active password
  swap_passwords = true
}

output "initial_active" {
# nonsensitive is used here for demonstration purposes.
#   In the real world, it is very bad practice to make passwords visible like this.
  value = nonsensitive(module.passwords_initial.active_password)
}
output "initial_backup" {
# nonsensitive is used here for demonstration purposes.
#   In the real world, it is very bad practice to make passwords visible like this.
  value = nonsensitive(module.passwords_initial.backup_password)
}

output "rotated_active" {
# nonsensitive is used here for demonstration purposes.
#   In the real world, it is very bad practice to make passwords visible like this.
  value = nonsensitive(module.passwords_rotated.active_password)

}
output "rotated_backup" {
# nonsensitive is used here for demonstration purposes.
#   In the real world, it is very bad practice to make passwords visible like this.
  value = nonsensitive(module.passwords_rotated.backup_password)

}

output "swapped_active" {
# nonsensitive is used here for demonstration purposes.
#   In the real world, it is very bad practice to make passwords visible like this.
  value = nonsensitive(module.passwords_swapped.active_password)

}
output "swapped_backup" {
  # nonsensitive is used here for demonstration purposes.
  #   In the real world, it is very bad practice to make passwords visible like this.
  value = nonsensitive(module.passwords_swapped.backup_password)

}
