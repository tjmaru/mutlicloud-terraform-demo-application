output "public_ip_address" {
  description = "The actual ip address allocated for the resource."
  value = coalesce(
    join("", module.aws_app.public_ip),
    join("", data.azurerm_public_ip.vm.*.ip_address),
    local.gcp ? google_compute_instance.vm.0.network_interface.0.access_config.0.nat_ip : "dummy"
  )
}
