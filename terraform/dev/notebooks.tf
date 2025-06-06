resource "databricks_repo" "gp_roster" {
  url    = "https://github.com/your-org/your-databricks-notebooks-repo.git"
  path   = "/Repos/your-email@example.com/gp-roster"
  branch = "main"
}

