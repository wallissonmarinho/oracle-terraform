resource "oci_core_volume_backup_policy" "backup_policy" {
  compartment_id = local.compartment_id
  display_name   = var.backup_policy_name
  depends_on     = [oci_identity_compartment._]

  schedules {
    backup_type       = "INCREMENTAL"
    period            = "ONE_DAY"
    retention_seconds = 604800
    time_zone         = "REGIONAL_DATA_CENTER_TIME"
  }

  schedules {
    backup_type       = "INCREMENTAL"
    period            = "ONE_WEEK"
    retention_seconds = 2419200
    time_zone         = "REGIONAL_DATA_CENTER_TIME"
  }

  schedules {
    backup_type       = "INCREMENTAL"
    period            = "ONE_MONTH"
    retention_seconds = 324691200
    time_zone         = "REGIONAL_DATA_CENTER_TIME"
  }
}

resource "oci_core_volume_backup_policy_assignment" "backup_policy_assignment" {
  depends_on = [oci_core_volume._,oci_core_volume_backup_policy.backup_policy]

  asset_id  = oci_core_volume._.id
  policy_id = oci_core_volume_backup_policy.backup_policy.id
}
