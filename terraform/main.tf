resource "azurerm_resource_group" "rg_keycloak" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "keycloak_network" {
  name                = var.keycloak_network
  address_space       = var.network_address_space
  location            = azurerm_resource_group.rg_keycloak.location
  resource_group_name = azurerm_resource_group.rg_keycloak.name
}

resource "azurerm_subnet" "keycloak_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg_keycloak.name
  virtual_network_name = azurerm_virtual_network.keycloak_network.name
  address_prefixes     = var.subnet_address_prefixes
}

resource "azurerm_public_ip" "keycloak_public_ip" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.rg_keycloak.location
  resource_group_name = azurerm_resource_group.rg_keycloak.name
  allocation_method   = var.allocation_method
  sku = var.public_ip_sku
}

resource "azurerm_network_interface" "keycloak_ni" {
  name                = var.network_interface_name
  location            = azurerm_resource_group.rg_keycloak.location
  resource_group_name = azurerm_resource_group.rg_keycloak.name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = azurerm_subnet.keycloak_subnet.id
    private_ip_address_allocation = var.private_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.keycloak_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "keycloak_vm" {
  name                = var.virtual_machine_name
  resource_group_name = azurerm_resource_group.rg_keycloak.name
  location            = azurerm_resource_group.rg_keycloak.location
  size                = var.virtual_machine_size
  admin_username      = var.virtual_machine_admin_username
  network_interface_ids = [
    azurerm_network_interface.keycloak_ni.id,
  ]

   admin_ssh_key {
     username   = var.virtual_machine_admin_username
     public_key = var.public_key  
     }

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_reference_publisher
    offer     = var.source_image_reference_offer
    sku       = var.source_image_reference_sku
    version   = var.source_image_reference_version
  }
}