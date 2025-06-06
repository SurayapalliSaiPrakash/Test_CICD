resource "databricks_notebook" "gporoster_import" {
  path     = "/Shared/gporoster/roster_data_import"
  language = "PYTHON"
  source   = "../../notebook/batch/gporoster/roster_data_import.py"
}
resource "databricks_job" "load_gporoster_premier_test" {
  name = "Load GPO Roster Premier Test"

  task {
    task_key = "run_gporoster_import"
    notebook_task {
      notebook_path = databricks_notebook.gporoster_import.path
    }
    existing_cluster_id = var.existing_cluster_id
  }
}

  
