# Databricks notebook source
dbutils.widgets.dropdown("load_type", "full", ["full", "incremental"],"01. Load Type")
dbutils.widgets.text("source_file_path", "","02. Source File Path")
dbutils.widgets.text("target_file_path", "","03. Target File Path")
dbutils.widgets.text("archive_file_path", "","04. Archive File Path")
dbutils.widgets.text("target_table", "","04. Target Table")
dbutils.widgets.text("primary_keys", "","05. Primary Keys")
dbutils.widgets.text("file_type", "","06. File Type")

# COMMAND ----------

# MAGIC %sh
# MAGIC pip install xlsx2csv

# COMMAND ----------

dbutils.library.restartPython()

# COMMAND ----------

import subprocess
import os
from datetime import datetime
from pyspark.sql.functions import lit, current_timestamp
import re
# from urllib.parse import urlparse

# COMMAND ----------

def get_files_in_volume(volume_path, format=".xlsx"):
  result = []
  files = dbutils.fs.ls(volume_path)
  if len(files) > 0:
    result = sorted(
        [f for f in files if f.name.lower().endswith(format) and not f.isDir()],
        key=lambda f: f.name
    )

  if len(result) > 0:
    print("Files to process in Volume:")
    for f in result:
      print(f"{f.path}")
  else:
    print(f"No files to process in Volume. Path {xlsx_file_path}")
  return result

def create_directory_if_not_exists(path):
  if not path.endswith("/"):
      path += "/"  # Ensure it’s treated as a directory
  try:
      dbutils.fs.ls(path)
  except:
      dbutils.fs.mkdirs(path)

def convert_xlsx_to_csv(xlsx_path, csv_path):
  # Convert only the first sheet, without formatting (faster)
  result = subprocess.run(["xlsx2csv", "-s", "1", xlsx_path, csv_path], capture_output=True, text=True)

  if result.returncode != 0:
      print(result)
      return "Error"
  else:
      print(result)
      return "Success"

def read_csv(csv_path, delimiter = None):
  if delimiter == None:    
    df = spark.read.option("header", "true").option("inferSchema", "true").csv(csv_path)
  else:
    df = spark.read.option("delimiter", delimiter ).option("header", "true").option("inferSchema", "true").csv(csv_path)
  return df

def cleaned_columns(df):
  cleaned_columns = [
      re.sub(r'[^\w]+', '_', col.strip()).rstrip("_") for col in df.columns
  ]
  df = df.toDF(*cleaned_columns)
  return df

# COMMAND ----------

load_type = dbutils.widgets.get("load_type").strip()
source_file_path = dbutils.widgets.get("source_file_path").strip()
target_file_path = dbutils.widgets.get("target_file_path").strip()
archive_file_path = dbutils.widgets.get("archive_file_path").strip()
target_table = dbutils.widgets.get("target_table").strip()
primary_keys = dbutils.widgets.get("primary_keys").strip()
file_type = dbutils.widgets.get("file_type").strip()

# COMMAND ----------

source_files = get_files_in_volume(source_file_path, f".{file_type}")
if len(source_files) == 0:
  print(f"No files to process in Volume. Path {source_file_path}")
  exit()
if load_type == "full":
  for f in source_files:
    print(f"Processing: {f.path}")
    
    #convert XLSX to csv
    create_directory_if_not_exists(target_file_path)
    if file_type.lower() == 'xlsx':
      result = convert_xlsx_to_csv(f"{source_file_path}{f.name}", f"{target_file_path}{(f.name)[:-5]}.csv")
      if result != "Success":
        raise Exception("XLSX to CSV conversion failed.")

      print(f"XLSX converted to CSV: {(f.name)[:-5]}.csv \nReading the CSV file")
      #read csv volume_csv_file_path
      df_src = read_csv(f"{target_file_path}{(f.name)[:-5]}.csv")
    elif file_type.lower() == 'txt.filepart':      
      dbutils.fs.cp(f"{source_file_path}{f.name}", f"{target_file_path}{f.name}")
      df_src = read_csv(f"{target_file_path}{f.name}","\t")
        
    df_src = cleaned_columns(df_src)
    df_src = df_src.withColumn("created_ts", lit(datetime.utcnow()))
    
    print(f"Total record count : {f.name} : {df_src.count()} \nWriting to table")
    df_src.write.format("delta").option("mergeSchema","true").mode("overwrite").saveAsTable(target_table)

    print(f"Archiving the file {archive_file_path}{f.name}")
    create_directory_if_not_exists(archive_file_path)
    dbutils.fs.mv(f"{source_file_path}{f.name}", f"{archive_file_path}{f.name}")
else:
  print("Load tpye not supported. Please use 'full'")

# COMMAND ----------
