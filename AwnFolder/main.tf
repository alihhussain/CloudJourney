# Define provider
provider "azurerm" {
  features {}
}

# Define variables
variable "resource_group_name" {
  description = "The name of the resource group"
  default     = "AwnjResourceGroup"
}

variable "location" {
  description = "The Azure region where the resources will be created"
  default     = "eastus"
}

variable "vm_name" {
  description = "The name of the virtual machine"
  default     = "AwnjVM"
}

variable "vm_size" {
  description = "The size of the virtual machine"
  default     = "Standard_DS1_v2"
}

variable "admin_username" {
  description = "The admin username for the virtual machine"
  default     = "azureuser"
}

variable "admin_password" {
  description = "The admin password for the virtual machine"
  default     = "Cloudjourney2023!"
  sensitive   = true
}

variable "nsg_name" {
  description = "The name of the network security group"
  default     = "AwnjNSG"
}

variable "nsg_rule_name" {
  description = "The name of the network security group rule"
  default     = "allowSSH"
}

# Create a resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Create a network security group
resource "azurerm_network_security_group" "main" {
  name                = var.nsg_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Create a rule in the NSG to allow SSH traffic (port 22)
resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = var.nsg_rule_name
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.main.name
}

# Create a virtual network
resource "azurerm_virtual_network" "main" {
  name                = "AwnjVnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

# Create a subnet
resource "azurerm_subnet" "main" {
  name                 = "AwnjSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a public IP address
resource "azurerm_public_ip" "main" {
  name                = "AwnjPublicIP"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create a network interface
resource "azurerm_network_interface" "main" {
  name                = "AwnjNIC"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

# Associate the NSG with the subnet
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# Create a virtual machine
resource "azurerm_virtual_machine" "main" {
  name                  = var.vm_name
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.vm_size

  storage_os_disk {
    name              = "${var.vm_name}_os_disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# Custom script to install Apache Tomcat
resource "azurerm_virtual_machine_extension" "main" {
  name                 = "install-tomcat"
  virtual_machine_id   = azurerm_virtual_machine.main.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
    {
      "commandToExecute": "sudo apt-get update && sudo apt-get install -y openjdk-11-jdk && wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.52/bin/apache-tomcat-9.0.52.tar.gz && tar -xvzf apache-tomcat-9.0.52.tar.gz && sudo mv apache-tomcat-9.0.52 /opt/tomcat && sudo chmod +x /opt/tomcat/bin/*.sh && sudo /opt/tomcat/bin/startup.sh"
    }
  SETTINGS
}

# Output the public IP address of the VM
output "public_ip" {
  value = azurerm_public_ip.main.ip_address
}
