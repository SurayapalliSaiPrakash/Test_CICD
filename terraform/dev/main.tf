resource "databricks_notebook" "gporoster_import" {
  path     = "/Shared/gporoster/roster_data_import"
  language = "PYTHON"
  source   = "../../notebook/batch/gporoster/roster_data_import.py"
}
resource "databricks_job" "load_gporoster_premier_test" {
  name = "ETL Job"
  new_cluster {
    num_workers   = 2
    spark_version = "12.2.x-scala2.12"
    node_type_id  = "Standard_DS3_v2"
  }

  notebook_task {
    notebook_path = databricks_notebook.my_notebook.path
  }
}

  
