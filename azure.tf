data "azurerm_resource_group" "vm" {
  name = var.resource_group_name
}

resource "azurerm_public_ip" "vm" {
  count               = local.azure ? 1 : 0
  name                = var.name
  resource_group_name = data.azurerm_resource_group.vm.name
  location            = data.azurerm_resource_group.vm.location
  allocation_method   = "Dynamic"
  tags                = var.tags
}

resource "azurerm_network_interface" "vm" {
  count               = local.azure ? 1 : 0
  name                = var.name
  resource_group_name = data.azurerm_resource_group.vm.name
  location            = data.azurerm_resource_group.vm.location

  ip_configuration {
    name                          = var.name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = join("", azurerm_public_ip.vm.*.id)
  }
}

resource "azurerm_virtual_machine" "app" {
  count                         = local.azure ? 1 : 0
  name                          = var.name
  resource_group_name           = data.azurerm_resource_group.vm.name
  location                      = data.azurerm_resource_group.vm.location
  vm_size                       = local.instance_type[var.instance_size][local.cloud]
  network_interface_ids         = azurerm_network_interface.vm.*.id
  delete_os_disk_on_termination = true
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name          = var.name
    create_option = "FromImage"
    caching       = "ReadWrite"
  }
  os_profile {
    computer_name  = var.name
    admin_username = "azureuser"
    admin_password = "Password1234!"
    custom_data    = local.user_data64
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file(format("%s/files/id_rsa.pub", path.module))
      path     = "/home/azureuser/.ssh/authorized_keys"
    }
  }
  tags = var.tags
  boot_diagnostics {
    enabled     = false
    storage_uri = ""
  }
}

resource "azurerm_network_security_group" "vm" {
  count               = local.azure ? 1 : 0
  name                = var.name
  resource_group_name = data.azurerm_resource_group.vm.name
  location            = data.azurerm_resource_group.vm.location
  tags                = var.tags
}

resource "azurerm_network_security_rule" "ssh" {
  count                       = local.azure ? 1 : 0
  name                        = "allow ssh"
  resource_group_name         = data.azurerm_resource_group.vm.name
  description                 = "Allow SSH in from all locations"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = 22
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = join("", azurerm_network_security_group.vm.*.name)
}

resource "azurerm_network_security_rule" "http" {
  count                       = local.azure ? 1 : 0
  name                        = "allow http"
  resource_group_name         = data.azurerm_resource_group.vm.name
  description                 = "Allow HTTP in from all locations"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = 80
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = join("", azurerm_network_security_group.vm.*.name)
}


data "azurerm_public_ip" "vm" {
  count               = local.azure ? 1 : 0
  name                = var.name
  resource_group_name = data.azurerm_resource_group.vm.name
  depends_on          = [azurerm_virtual_machine.app]
}
