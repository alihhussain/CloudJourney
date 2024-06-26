# terraform.tfvars
location            = "West Europe"
resource_group_name = "example-resources"
vnet_name           = "example-network"
address_space       = "10.0.0.0/16"
subnet_name         = "internal"
subnet_prefix       = "10.0.2.0/24"
vm_name             = "example-vm"
vm_size             = "Standard_DS1_v2"
admin_username      = "adminuser"
admin_password      = "Password1234!"
