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

variable "admin_password" { 
  description = "Administrator password for the Azure VM"
  type        = string
  default = "Cloudjourney@1"
  // It's recommended to not set a default password here for security reasons.
}
  

