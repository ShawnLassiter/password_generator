# outputs.tf

output "active_password" {
  description = "The current designated active password."
  value       = local.final_active_password
  sensitive   = true # Important to hide sensitive data in CLI output
}

output "backup_password" {
  description = "The current designated backup password."
  value       = local.final_backup_password
  sensitive   = true # Important to hide sensitive data in CLI output
}
