resource "databricks_notebook" "load_gporoster_premier" {
  path     = "/Workspace/Shared/Notebooks/load_gporoster_premier"
  language = "PYTHON"
  source   = "../../notebook/batch/gporoster/load_gporoster_premier.py"
}
