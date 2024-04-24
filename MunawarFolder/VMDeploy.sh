#!/bin/bash

# Configuration variables
location="EastUS"
resourceGroupName="MResourceGroup"
vmName="MVM"
nsgName="MNSG"
vnetName="MVNet"
subnetName="MSubnet"
publicIpName="MPublicIP"
nicName="MNIC"
vmSize="Standard_B1s"
image="Ubuntu2204"
adminUsername="azureuser"
adminPassword="Cloudjourney123"

# Create a resource group
echo "Creating resource group..."
az group create --name $resourceGroupName --location $location

# Create Network Security Group and rule
echo "Creating Network Security Group..."
az network nsg create --resource-group $resourceGroupName --name $nsgName
az network nsg rule create --resource-group $resourceGroupName --nsg-name $nsgName --name AllowSSH --protocol Tcp --priority 1000 --destination-port-range 22 --access Allow --direction Inbound

# Create virtual network and subnet, attach NSG to subnet
echo "Creating virtual network and subnet..."
az network vnet create --resource-group $resourceGroupName --name $vnetName --address-prefix 10.0.0.0/24 --subnet-name $subnetName --subnet-prefix 10.0.0.0/24 --location $location
az network vnet subnet update --resource-group $resourceGroupName --vnet-name $vnetName --name $subnetName --network-security-group $nsgName

echo "Creating NSG rule for HTTPS..."
az network nsg rule create --resource-group $resourceGroupName --nsg-name $nsgName --name AllowHTTPS --protocol Tcp --priority 1010 --destination-port-range 443 --access Allow --direction Inbound

# Create a public IP address
echo "Creating public IP address..."
az network public-ip create --resource-group $resourceGroupName --name $publicIpName

# Create a network interface
echo "Creating network interface..."
az network nic create --resource-group $resourceGroupName --name $nicName --vnet-name $vnetName --subnet $subnetName --public-ip-address $publicIpName

# Create a virtual machine
echo "Creating virtual machine..."
az vm create --resource-group $resourceGroupName --location $location --name $vmName --nics $nicName --image $image --admin-username $adminUsername --admin-password $adminPassword --size $vmSize --no-wait