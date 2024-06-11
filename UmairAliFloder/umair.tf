provider "azurerm" {
  features {}
  version = "~> 2.0"
}

variable "resource_group_name" {
  type    = string
  default = "myResourceGroup"
}

variable "location" {
  type    = string
  default = "East US"
}

variable "vm_name" {
  type    = string
  default = "myLinuxVM"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "vm_size" {
  type    = string
  default = "Standard_DS1_v2"
}

variable "admin_ssh_key" {
  type    = string
  default = "ssh-rsa AAAA..."
}

