resource "mongodbatlas_privatelink_endpoint" "region" {
  project_id    = var.atlas_proj_id 
  provider_name = var.provider_name
  region        = var.provider_region
}

resource "mongodbatlas_privatelink_endpoint_service" "region" {
  project_id            = mongodbatlas_privatelink_endpoint.region.project_id
  private_link_id       = mongodbatlas_privatelink_endpoint.region.private_link_id
  endpoint_service_id   = azurerm_private_endpoint.atlas-group.id
  private_endpoint_ip_address = azurerm_private_endpoint.atlas-group.private_service_connection.0.private_ip_address
  provider_name         = var.provider_name
}

resource "azurerm_private_endpoint" "atlas-group" {
  name                = var.endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  private_service_connection {
    name                           = mongodbatlas_privatelink_endpoint.region.private_link_service_name
    private_connection_resource_id = mongodbatlas_privatelink_endpoint.region.private_link_service_resource_id

    is_manual_connection           = true    
    request_message = "Azure Private Link test"
  }   
}

//Peering to 2 other regions
resource "azurerm_virtual_network_peering" "outbound0" {
  name                      = var.peering_regions_name[0]
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.virtual_network_name
  remote_virtual_network_id = var.remote_vpc_ids[0]

  // depends_on = [ azurerm_virtual_network.atlas-group[0], azurerm_virtual_network.atlas-group[1] ]
}

resource "azurerm_virtual_network_peering" "outbound1" {
  name                      = var.peering_regions_name[1]
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.virtual_network_name
  remote_virtual_network_id = var.remote_vpc_ids[1]

  //depends_on = [ azurerm_virtual_network.atlas-group[0], azurerm_virtual_network.atlas-group[2] ]
}