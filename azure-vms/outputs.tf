output "public_ip_address" {
  description = "Public IP of azure VM"
  value       = azurerm_linux_virtual_machine.demo-vm.*.public_ip_address
}

output "subnet_id" {
    value = azurerm_subnet.atlas-group.id
}

output "vpc_id" {
    value= azurerm_virtual_network.atlas-group.id
}

// Could be remove - are available as inputs in locals.tf
output "resource_group_name" {
  value= azurerm_resource_group.atlas-group.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.atlas-group.name
}
