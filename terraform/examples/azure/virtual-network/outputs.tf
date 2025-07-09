# Azure Virtual Network Outputs

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.main.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_address_space" {
  description = "Address space of the virtual network"
  value       = azurerm_virtual_network.main.address_space
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = azurerm_subnet.public.id
}

output "public_subnet_name" {
  description = "Name of the public subnet"
  value       = azurerm_subnet.public.name
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = azurerm_subnet.private.id
}

output "private_subnet_name" {
  description = "Name of the private subnet"
  value       = azurerm_subnet.private.name
}

output "public_nsg_id" {
  description = "ID of the public network security group"
  value       = azurerm_network_security_group.public.id
}

output "private_nsg_id" {
  description = "ID of the private network security group"
  value       = azurerm_network_security_group.private.id
}

output "nat_gateway_id" {
  description = "ID of the NAT gateway"
  value       = azurerm_nat_gateway.main.id
}

output "nat_gateway_public_ip" {
  description = "Public IP address of the NAT gateway"
  value       = azurerm_public_ip.nat_gateway.ip_address
}