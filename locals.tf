locals {
  # New empty Atlas project name to create in organization
  project_name          = "Multi-Region-Azure-Linked-Project"
  # Atlas region, https://docs.atlas.mongodb.com/reference/microsoft-azure/#microsoft-azure
  region                = "EUROPE_WEST"
  # Atlas cluster name
  cluster_name		      = "Sample-MultiRegion01"
  # Atlas Public providor
  provider_name         = "AZURE"
  # Provider Region
  provider_region1       = "westeurope"
  # Provider Region
  provider_region2       = "northeurope"
  # Provider Region
  provider_region3       = "germanywestcentral"
  


  # A Azure resource group
  resource_group_name1   = "atlas-demo-link-west"
  # A Azure resource group
  resource_group_name2   = "atlas-demo-link-north"
  # A Azure resource group
  resource_group_name3   = "atlas-demo-link-central"
  # Associated Azure vnet
  vnet_name1             = "atlas-link-vnet-west"
  # Associated Azure vnet
  vnet_name2             = "atlas-link-vnet-north"
  # Associated Azure vnet
  vnet_name3             = "atlas-link-vnet-central"
  # Azure location
  location1              = "West Europe"
  # Azure location
  location2              = "North Europe"
  # Azure location
  location3              = "Germanywest central"
  
  # Azure cidr block for vnet
  address_space1         = ["10.12.4.0/23"]
  # Azure cidr block for vnet
  address_space2         = ["10.13.4.0/23"]
  # Azure cidr block for vnet
  address_space3         = ["10.14.4.0/23"]
  # Azure subnet in vnet
  subnet1                = "subnet1"
  # Azure subnet in vnet
  subnet2                = "subnet2"
  # Azure subnet in vnet
  subnet3                = "subnet3"
  # Azure subnet cidr
  subnet_address_space1  = "10.12.4.192/26"
  # Azure subnet cidr
  subnet_address_space2  = "10.13.4.192/26"
  # Azure subnet cidr
  subnet_address_space3  = "10.14.4.192/26"
  # Azure vm admin_user
  admin_username        = "testuser"
  # Azure vm size
  azure_vm_size		      = "Standard_F2"
  # Azure vm_name	
  azure_vm_name1		      = "demo-link-west"
  # Azure vm_name	
  azure_vm_name2		      = "demo-link-north"
  # Azure vm_name	
  azure_vm_name3		      = "demo-link-central"
}
 
