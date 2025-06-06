resources:
  jobs:
    load_gporoster_premier_test:
      name: load_gporoster_premier_test
      trigger:
        pause_status: PAUSED
        file_arrival:
          url: abfss://sftp@fffdevdbricksuc.dfs.core.windows.net/premier/
          min_time_between_triggers_seconds: 120
          wait_after_last_change_seconds: 120
      tasks:
        - task_key: import_premier_roster
          notebook_task:
            notebook_path: /Users/vbatulla@fffenterprises.com/development/data_load/gporoster/roster_data_import
            base_parameters:
              load_type: full
              target_table: dev_catalog.gporoster.premier_roster
              source_file_path: /Volumes/dev_catalog/gporoster/gporoster_vol/premier/
              target_file_path: /Volumes/dev_catalog/gporoster/gporoster_vol/output/premier/
              archive_file_path: /Volumes/dev_catalog/gporoster/gporoster_vol/archive/premier/
              file_type: xlsx
      queue:
        enabled: true
      performance_target: STANDARD
  
