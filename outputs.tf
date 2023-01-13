output "public_ip_address" {
  description = "The actual ip address allocated for the resource."
  value = coalesce(
    local.gcp ? google_compute_instance.vm.0.network_interface.0.access_config.0.nat_ip : "dummy"
  )
}
