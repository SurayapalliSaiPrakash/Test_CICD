resource "databricks_notebook" "my_notebook" {
  path     = "/Shared/ETL_Demo"
  language = "PYTHON"
  source   = "notebooks/etl_job.py"
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
resource "databricks_pipeline" "dlt_pipeline" {
  name = "sample_dlt_pipeline"
  storage = "dbfs:/pipelines/storage"
  target = "sample_target"

  cluster {
    num_workers   = 2
    spark_version = "12.2.x-scala2.12"
    node_type_id  = "Standard_DS3_v2"
  }

  configuration = {
    "spark.master" = "local[*]"
  }

  libraries {
    notebook {
      path = databricks_notebook.my_notebook.path
    }
  }
}

resource "databricks_catalog" "my_catalog" {
  name         = "my_catalog"
  comment      = "Managed by Terraform"
  isolation_mode = "OPEN"
}

resource "databricks_schema" "my_schema" {
  name        = "my_schema"
  catalog_name = databricks_catalog.my_catalog.name
  comment     = "Schema created with Terraform"
}
