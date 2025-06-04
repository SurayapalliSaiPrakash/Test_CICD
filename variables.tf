variable "databricks_host" {
  type        = string
  description = "Workspace URL (e.g., https://<workspace>.cloud.databricks.com)"
}

variable "databricks_token" {
  type        = string
  description = "Personal Access Token or Service Principal token"
  sensitive   = true
}