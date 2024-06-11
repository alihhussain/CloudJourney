# Define variables
variable "resource_group_name" {
  description = "The name of the resource group"
  default     = "FYRGP2"
}

variable "location" {
  description = "The Azure region where the resources will be created"
  default     = "eastus"
}

variable "vm_name" {
  description = "The name of the virtual machine"
  default     = "fyvm"
}

variable "vm_size" {
  description = "The size of the virtual machine"
  default     = "Standard_DS1_v2"
}

variable "admin_username" {
  description = "The admin username for the virtual machine"
  default     = "azureuser6"
}

variable "admin_password" {
  description = "The admin password for the virtual machine"
  default     = "Cloudjourney2023!"
  sensitive   = true
}

variable "nsg_name" {
  description = "The name of the network security group"
  default     = "fynsg"
}

variable "nsg_rule_name" {
  description = "The name of the network security group rule"
  default     = "allowSSH"
}