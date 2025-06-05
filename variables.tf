variable "databricks_host" {
  type        = string
  description = "https://adb-1716834444966310.10.azuredatabricks.net"
}

variable "databricks_token" {
  type        = string
  description = "Personal Access Token or Service Principal token"
  sensitive   = true
}
