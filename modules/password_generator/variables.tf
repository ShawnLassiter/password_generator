# variables.tf

variable "password_length" {
  description = "The length of the generated passwords."
  type        = number
  default     = 24
}

variable "include_special" {
  description = "Include special characters in the password."
  type        = bool
  default     = true
}

variable "special_characters" {
  description = "Specific set of special characters to use (overrides default)."
  type        = string
  default     = "!@#$%^&*"
}

variable "rotate_backup" {
  description = "Change this value (e.g., to a timestamp or a random string) to force regeneration of the BACKUP password only."
  type        = string
  default     = "initial-run"
}

variable "swap_passwords" {
  description = "Set to true to swap the final output of the active and backup passwords."
  type        = bool
  default     = false
}
