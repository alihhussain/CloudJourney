variable "location" {
  description = "The location where resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "The address space of the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_names" {
  description = "A list of subnet names"
  type        = string
}

variable "subnet_prefixes" {
  description = "A list of subnet prefixes that must be within the Virtual Network address space"
  type        = string
}
