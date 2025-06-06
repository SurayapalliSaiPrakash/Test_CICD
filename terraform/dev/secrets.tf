resource "databricks_secret_scope" "gp_roster" {
  name                    = "dev-gp-roster-scope"
  initial_manage_principal = "users"
}

resource "databricks_secret" "db_password" {
  key          = "db_password"
  string_value = var.db_password
  scope        = databricks_secret_scope.gp_roster.name
}
