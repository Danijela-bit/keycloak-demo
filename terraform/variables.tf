variable "client_secret" {
  type    = string
  description = "Service Principal token used as client_secret"
  sensitive = true
}

variable "client_id" {
  type    = string
  description = "Service Principal token used as client_id"
  sensitive = true
}

variable "tenant_id" {
  type    = string
  description = "Service Principal token used as tenant_id"
  sensitive = true
}

variable "subscription_id" {
  type    = string
  description = "Azure Subscription ID"
  sensitive = true
}

variable "resource_group_name" {
  type    = string
  default = "rg-keycloak-demo"
  description = "Azure Resource group name"
}

variable "location" {
  type    = string
  default = "West Europe"
  description = "Azure Resource group location"
}

variable "keycloak_network" {
  type    = string
  default = "keycloak-network"
  description = "Azure Virtual Network name"
}

variable "network_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
  description = "Azure Virtual Network address space"
}

variable "subnet_name" {
  type    = string
  default = "keycloak-subnet-internal"
  description = "Azure Subnet name"
}

variable "subnet_address_prefixes" {
  type    = list(string)
  default = ["10.0.2.0/24"]
  description = "Azure Subnet address prefixes"
}

variable "public_ip_name" {
  type    = string
  default = "keycloak-public-ip"
  description = "Azure Public IP name"
}

variable "public_ip_sku" {
  type    = string
  default = "Basic"
  description = "The SKU of the Public IP"
}

variable "allocation_method" {
  type    = string
  default = "Dynamic"
  description = "Allocation method for Public IP"
}

variable "network_interface_name" {
  type    = string
  default = "keycloak-network-interface"
  description = "Azure Network Interface name"
}

variable "ip_configuration_name" {
  type    = string
  default = "keycloak-internal"
  description = "Network Interface IP configuration name"
}

variable "private_ip_address_allocation" {
  type    = string
  default = "Dynamic"
  description = "Network Interface private IP address allocation"
}

variable "virtual_machine_name" {
  type    = string
  default = "keycloak-vm"
  description = "Demo Azure virtual machine name"
}

variable "virtual_machine_size" {
  type    = string
  default = "Standard_D2ads_v6"
  description = "Demo Azure virtual machine size"
}

variable "virtual_machine_admin_username" {
  type    = string
  description = "Demo Azure virtual machine admin username"
}

variable "public_key" {
  type    = string
  description = "SSH public key"
}

variable "os_disk_caching" {
  type    = string
  default = "ReadWrite"
  description = "OS disk caching"
}

variable "os_disk_storage_account_type" {
  type    = string
  default = "Standard_LRS"
  description = "OS disk storage account type"
}

variable "source_image_reference_publisher" {
  type    = string
  default = "Canonical"
  description = "Source image reference publisher"
}

variable "source_image_reference_offer" {
  type    = string
  default = "ubuntu-24_04-lts"
  description = "Source image reference offer"
}

variable "source_image_reference_sku" {
  type    = string
  default = "server"
  description = "Source image reference SKU-Stock Keeping Unit"
}

variable "source_image_reference_version" {
  type    = string
  default = "latest"
  description = "Source image reference versionr"
}

output "public_ip" {
  description = "Public IP address of the Azure VM"
  value       = azurerm_linux_virtual_machine.keycloak_vm.public_ip_address
}