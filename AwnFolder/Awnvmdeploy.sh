#!/bin/bash

# Variables
resourceGroup="AwnjResourceGroup"
location="eastus"
vmName="AwnjVM"
vmSize="Standard_DS1_v2"
adminUser="azureuser"
adminPassword="Cloudjourney2023!"
nsgName="AwnjNSG"
nsgRuleName="allowSSH"

# Create a resource group
az group create --name $resourceGroup --location $location

# Create a network security group
az network nsg create --resource-group $resourceGroup --name $nsgName

# Create a rule in the NSG to allow SSH traffic (port 22)
az network nsg rule create --resource-group $resourceGroup --nsg-name $nsgName --name $nsgRuleName --protocol Tcp --direction Inbound --priority 1000 --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' --destination-port-ranges 22 --access Allow

# Create a virtual network
az network vnet create --resource-group $resourceGroup --name AwnjVnet --subnet-name AwnjSubnet

# Create a public IP address
az network public-ip create --resource-group $resourceGroup --name AwnjPublicIP --sku Standard --allocation-method Static

# Create a network interface
az network nic create --resource-group $resourceGroup --name AwnjNIC --vnet-name AwnjVnet --subnet AwnjSubnet --public-ip-address AwnjPublicIP --network-security-group $nsgName

# Create a virtual machine
az vm create \
  --resource-group $resourceGroup \
  --name $vmName \
  --image Ubuntu2204 \
  --admin-username $adminUser \
  --admin-password $adminPassword \
  --size $vmSize \
  --nics AwnjNIC \
  --authentication-type password
