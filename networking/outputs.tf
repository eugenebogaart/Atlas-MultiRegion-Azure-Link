output "private_ip_address" {
    value = azurerm_private_endpoint.atlas-group.private_service_connection.0.private_ip_address
}

output "private_endpoint_id" {
    value = azurerm_private_endpoint.atlas-group.id
}