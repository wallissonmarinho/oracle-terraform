resource "oci_identity_compartment" "_" {
  name          = var.compartment
  description   = var.compartment
  enable_delete = true
}

locals {
  compartment_id = oci_identity_compartment._.id
}

data "oci_identity_availability_domains" "_" {
  compartment_id = local.compartment_id
}

data "oci_core_images" "_" {
  compartment_id           = local.compartment_id
  shape                    = var.shape
  operating_system         = var.operating_system
  operating_system_version = var.operating_system_version
}

resource "oci_core_instance" "_" {
  for_each            = local.nodes
  display_name        = each.value.node_name
  availability_domain = data.oci_identity_availability_domains._.availability_domains[var.availability_domain].name
  compartment_id      = local.compartment_id
  shape               = var.shape
  shape_config {
    memory_in_gbs = var.memory_in_gbs_per_node
    ocpus         = var.ocpus_per_node
  }
  source_details {
    source_id   = data.oci_core_images._.images[0].id
    source_type = "image"
  }
  create_vnic_details {
    subnet_id  = oci_core_subnet._.id
    private_ip = each.value.ip_address
  }
  metadata = {
    ssh_authorized_keys = join("\n", local.authorized_keys)
    user_data           = data.cloudinit_config._[each.key].rendered
  }
  connection {
    host        = self.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.ssh.private_key_pem
  }
  provisioner "remote-exec" {
    inline = [
      "sudo timedatectl set-timezone UTC",
      "tail -f /var/log/cloud-init-output.log &",
      "cloud-init status --wait >/dev/null",
    ]
  }
}

locals {
  nodes = {
    for i in range(1, 1 + var.how_many_nodes) :
    i => {
      node_name  = format("dev-instance-arm-%d", i)
      ip_address = format("10.0.0.%d", 10 + i)
      role       = i == 1 ? "controlplane" : "worker"
    }
  }
}