variable "backup_policy_name" {
  type    = string
  default = "dev-k8s-gold-policy"
}

variable "block_storage_name" {
  type    = string
  default = "dev-k8s-storage"
}

variable "backup_policy_time_zone" {
  type    = string
  default = "UTC"
}

variable "block_storage_size" {
  type    = number
  default = 150
}

variable "compartment" {
  type    = string
  default = "dev-k8s-on-arm"
}

variable "operating_system" {
  type    = string
  default     = "Canonical Ubuntu"
}

variable "operating_system_version" {
  type    = string
  default     = "22.04"
}

/*
Available flex shapes:
"VM.Optimized3.Flex"  # Intel Ice Lake
"VM.Standard3.Flex"   # Intel Ice Lake
"VM.Standard.A1.Flex" # Ampere Altra
"VM.Standard.E3.Flex" # AMD Rome
"VM.Standard.E4.Flex" # AMD Milan
"VM.Standard.E2.1.Micro" # AMD Milan
*/

variable "shape" {
  type    = string
  default = "VM.Standard.A1.Flex"
}

variable "how_many_nodes" {
  type    = number
  default = 1
}

variable "availability_domain" {
  type    = number
  default = 1
}

variable "ocpus_per_node" {
  type    = number
  default = 4
}

variable "memory_in_gbs_per_node" {
  type    = number
  default = 24
}
