provider "azurerm" {
    # whilst the `version` attribute is optional,
    # we recommend pinning to a given version of the Provider
    subscription_id = var.azure_subscription_id
    tenant_id = var.azure_tenant_id
    features {}
}

module "azure-west" {
  source = "./azure-vms"
  resource_group_name = local.resource_group_name1 
  location = local.location1
  vnet_name = local.vnet_name1
  address_space = local.address_space1
  subnet = local.subnet1
  subnet_address_space = local.subnet_address_space1
  public_ip_name = "myPublicIP1"
  sg_name = "myAtlasDemo1"
  source_ip = var.source_ip
  vm_name = local.azure_vm_name1
  azure_vm_size = local.azure_vm_size
  public_key_path = var.public_key_path
  admin_username = local.admin_username
  admin_password = var.admin_password
  private_key_path = var.private_key_path
}

module "azure-north" {
  source = "./azure-vms"
  resource_group_name = local.resource_group_name2 
  location = local.location2
  vnet_name = local.vnet_name2
  address_space = local.address_space2
  subnet = local.subnet2
  subnet_address_space = local.subnet_address_space2
  public_ip_name = "myPublicIP2"
  sg_name = "myAtlasDemo2"
  source_ip = var.source_ip
  vm_name = local.azure_vm_name2
  azure_vm_size = local.azure_vm_size
  public_key_path = var.public_key_path
  admin_username = local.admin_username
  admin_password = var.admin_password
  private_key_path = var.private_key_path
}

module "azure-central" {
  source = "./azure-vms"
  resource_group_name = local.resource_group_name3 
  location = local.location3
  vnet_name = local.vnet_name3
  address_space = local.address_space3
  subnet = local.subnet3
  subnet_address_space = local.subnet_address_space3
  public_ip_name = "myPublicIP3"
  sg_name = "myAtlasDemo3"
  source_ip = var.source_ip
  vm_name = local.azure_vm_name3
  azure_vm_size = local.azure_vm_size
  public_key_path = var.public_key_path
  admin_username = local.admin_username
  admin_password = var.admin_password
  private_key_path = var.private_key_path
}

module "networking-west" {
  source = "./networking"

  // Private Endpoint parameters Atlas
  atlas_proj_id = module.atlas.atlas_proj_id
  provider_name = local.provider_name 
  provider_region = local.provider_region1
  
  // Private Endpoint parameters Azure
  endpoint_name = "endpoint-atlas-west"
  location = local.location1
  resource_group_name = local.resource_group_name1
  subnet_id = module.azure-west.subnet_id

  // Azure Peering parameters
  virtual_network_name = module.azure-west.virtual_network_name
  peering_regions_name = [ "westnorth", "westcentral"]
  remote_vpc_ids = [ module.azure-north.vpc_id, module.azure-central.vpc_id ]

  depends_on = [ module.azure-north, module.azure-central]
}

module "networking-north" {
  source = "./networking"

  // Private Endpoint parameters Atlas
  atlas_proj_id = module.atlas.atlas_proj_id
  provider_name = local.provider_name 
  provider_region = local.provider_region2
  
  // Private Endpoint parameters Azure
  endpoint_name = "endpoint-atlas-north"
  location = local.location2
  resource_group_name = local.resource_group_name2
  subnet_id = module.azure-north.subnet_id
 
  // Azure Peering parameters
  virtual_network_name = module.azure-north.virtual_network_name
  peering_regions_name = [ "northwest", "northcentral"]
  remote_vpc_ids = [ module.azure-west.vpc_id, module.azure-central.vpc_id]

  depends_on = [ module.azure-west, module.azure-central]
}

module "networking-central" {
  source = "./networking"

  // Private Endpoint parameters Atlas
  atlas_proj_id = module.atlas.atlas_proj_id
  provider_name = local.provider_name 
  provider_region = local.provider_region3

  // Private Endpoint parameters Azure
  endpoint_name = "endpoint-atlas-central"
  location = local.location3
  resource_group_name = local.resource_group_name3
  subnet_id = module.azure-central.subnet_id

  // Azure Peering parameters
  virtual_network_name = module.azure-central.virtual_network_name
  peering_regions_name = [ "centralnorth", "centralwest"]
  remote_vpc_ids = [ module.azure-north.vpc_id, module.azure-west.vpc_id]

  depends_on = [ module.azure-north, module.azure-west]
}

module "atlas" {
  source = "./atlas"

  admin_username = local.admin_username
  admin_password = var.admin_password
  cluster_name = local.cluster_name
  atlas_organization_id = var.atlas_organization_id
  provider_name = local.provider_name
  project_name = local.project_name

}