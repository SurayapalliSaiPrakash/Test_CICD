# notebooks/etl_job.py

# Databricks notebook source
# COMMAND ----------

# Sample ETL Job in Databricks using PySpark

from pyspark.sql import SparkSession

# Initialize Spark session (already available in Databricks by default)
spark = SparkSession.builder.appName("ETL_Job").getOrCreate()

# Step 1: Extract
data = [
    {"id": 1, "name": "Alice", "age": 29},
    {"id": 2, "name": "Bob", "age": 35},
    {"id": 3, "name": "Charlie", "age": 50}
]
df = spark.createDataFrame(data)

# Step 2: Transform
df_filtered = df.filter(df.age > 30)

# Step 3: Load
df_filtered.write.mode("overwrite").format("delta").save("/tmp/etl_output")

print("ETL job completed successfully.")

