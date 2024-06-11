# Initialize the provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "RG" {
  name     = "FYRG" # EDIT: Resource group name
  location = "East US" # EDIT: Azure region
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "fyvnet" # EDIT: Virtual network name
  address_space       = ["10.0.0.0/24"] # EDIT: Address space
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
}

# Create a subnet
resource "azurerm_subnet" "subnet" {
  name                 = "fysubnet" # EDIT: Subnet name
  resource_group_name  = azurerm_resource_group.RG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"] # EDIT: Subnet address prefix
}

# Create a network security group
resource "azurerm_network_security_group" "nsg" {
  name                = "fynsg" # EDIT: Network security group name
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
}

# Create a network interface
resource "azurerm_network_interface" "nic" {
  name                = "fynic"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.fysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.PIP.id
  }
}

# Create a public IP
resource "azurerm_public_ip" "PIP" {
  name                = "fypip"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  allocation_method   = "Dynamic"
}

# Create a Linux virtual machine
resource "azurerm_linux_virtual_machine" "fyvm" {
  name                = var.vm_name
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
  size                = var.vmSize

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
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

# Create managed disks for OS, Data1, Data2, and Temp
resource "azurerm_managed_disk" "os_disk" {
  name                 = "OSD-osdisk"
  location             = azurerm_resource_group.RG.location
  resource_group_name  = azurerm_resource_group.RG.name
  storage_account_type = "Standard_LRS"
  create_option        = "FromImage"
}

resource "azurerm_managed_disk" "data_disk1" {
  name                 = "OSD1-datadisk1"
  location             = azurerm_resource_group.RG.location
  resource_group_name  = azurerm_resource_group.RG.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_managed_disk" "data_disk2" {
  name                 = "OSD2-datadisk2"
  location             = azurerm_resource_group.RG.location
  resource_group_name  = azurerm_resource_group.RG.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

resource "azurerm_managed_disk" "temp_disk" {
  name                 = "TD-tempdisk"
  location             = azurerm_resource_group.RG.location
  resource_group_name  = azurerm_resource_group.RG.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}

# Attach data disks to the VM
resource "azurerm_virtual_machine_data_disk_attachment" "data_disk1_attachment" {
  managed_disk_id    = azurerm_managed_disk.data_disk1.id
  virtual_machine_id = azurerm_linux_virtual_machine.fyvm.id
  lun                = 0
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk2_attachment" {
  managed_disk_id    = azurerm_managed_disk.data_disk2.id
  virtual_machine_id = azurerm_linux_virtual_machine.fyvm.id
  lun                = 1
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine_data_disk_attachment" "temp_disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.temp_disk.id
  virtual_machine_id = azurerm_linux_virtual_machine.fyvm.id
  lun                = 2
  caching            = "ReadWrite"
}

# Create Diagnostic Logs
resource "azurerm_monitor_diagnostic_setting" "diagnostic" {
  name               = "fydiagnostics"
  target_resource_id = azurerm_linux_virtual_machine.fyvm.id

  storage_account_id = azurerm_storage_account.storage.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }

  log {
    category = "AllLogs"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }
}

# Create a storage account for logs
resource "azurerm_storage_account" "storage" {
  name                     = "fystorageacc"
  resource_group_name      = azurerm_resource_group.RG.name
  location                 = azurerm_resource_group.RG.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}