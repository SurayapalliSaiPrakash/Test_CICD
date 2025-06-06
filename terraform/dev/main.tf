resource "databricks_notebook" "gporoster_import" {Add commentMore actions
  path     = "/Shared/gporoster/roster_data_import"
  language = "PYTHON"
  source   = "../../notebook/batch/gporoster/roster_data_import.py"
}
resource "databricks_job" "load_gporoster_premier_test" {
  name = "Load GPO Roster Premier Test"

  task {
    task_key = "run_gporoster_import"
    notebook_task {
      notebook_path = /Workspace/Users/vbatulla@fffenterprises.com/.bundle/${BUNDLE_NAME}/dev/files/notebooks/batch/gporoster/roster_data_import.path
    }
    existing_cluster_id = var.existing_cluster_id
  }
}
