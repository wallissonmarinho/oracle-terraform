resource "oci_core_volume" "_" {
  compartment_id      = local.compartment_id
  display_name        = var.block_storage_name
  size_in_gbs         = 150
  availability_domain = data.oci_identity_availability_domains._.availability_domains[var.availability_domain].name
}

resource "oci_core_volume_attachment" "_" {
  for_each        = local.nodes
  display_name    = "dev-k8s-storage-attachment-${each.key}"
  volume_id       = oci_core_volume._.id
  instance_id     = oci_core_instance._[each.key].id
  attachment_type = "iscsi"
}
