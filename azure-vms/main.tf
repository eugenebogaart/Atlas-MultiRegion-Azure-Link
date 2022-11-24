

# Create a resource group
resource "azurerm_resource_group" "atlas-group" {
    name     = var.resource_group_name
    location = var.location

    tags = {
        environment = "Atlas Demo"
    }
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "atlas-group" {
    name                = var.vnet_name
    resource_group_name = azurerm_resource_group.atlas-group.name
    location            = var.location
    address_space       = var.address_space
 
    tags = {
        environment = "Atlas Demo"
    }
}

# Create a subnet in virtual network,
resource "azurerm_subnet" "atlas-group" {
    name                 = var.subnet
    address_prefixes     = [ var.subnet_address_space ]
    resource_group_name  = azurerm_resource_group.atlas-group.name
    virtual_network_name = azurerm_virtual_network.atlas-group.name

    enforce_private_link_service_network_policies = true
    enforce_private_link_endpoint_network_policies = true
}


resource "azurerm_public_ip" "demo-vm-ip" {
    name                         = var.public_ip_name
    # Looks like changed in azurerm
    # location                     = local.location_alt
    location                     = var.location
    resource_group_name          = azurerm_resource_group.atlas-group.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Atlas Demo"
    }
}


# Create Network Security Group and rule
resource "azurerm_network_security_group" "demo-vm-nsg" {
    name                = var.sg_name
    # Looks like changed in azurerm
    # location            = local.location_alt
    location            = var.location
    resource_group_name = azurerm_resource_group.atlas-group.name

    # Allow inbound SSH traffic
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = var.source_ip
        destination_address_prefix = "*"
    }

    tags = {
        environment                = "Atlas Demo"
    }
}

# Create network interface
resource "azurerm_network_interface" "demo-vm-nic" {
    name                      = "myNIC"
    location                  = azurerm_network_security_group.demo-vm-nsg.location
    resource_group_name       = azurerm_resource_group.atlas-group.name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.atlas-group.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.demo-vm-ip.id
    }

    tags = {
        environment = "Atlas Demo"
    }

    # depends_on = [ azurerm_network_interface.demo-vm-nic ]
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "demo-vm" {
    network_interface_id      = azurerm_network_interface.demo-vm-nic.id
    network_security_group_id = azurerm_network_security_group.demo-vm-nsg.id
}

resource "azurerm_linux_virtual_machine" "demo-vm" {

   name = var.vm_name
   location =var.location
   resource_group_name   =  azurerm_resource_group.atlas-group.name
   network_interface_ids = [ azurerm_network_interface.demo-vm-nic.id, ]

   size                  = var.azure_vm_size
   admin_username        = var.admin_username
   admin_password        = var.admin_password

   admin_ssh_key {
       username   = var.admin_username
       public_key = file(var.public_key_path)
   }

   os_disk {     
       caching              = "ReadWrite"
       storage_account_type = "Standard_LRS"
   }

   source_image_reference {
       publisher         = "Canonical"
       offer             = "UbuntuServer"
       sku               = "18.04-LTS"
       version           = "latest"
   }

   tags = {
       environment       = "Demo"
   }

   connection {
       disable_password_authentication = true
       type 				= "ssh"
       host 				= self.public_ip_address
       user 				= self.admin_username
       password 			= self.admin_password
       agent 				= true
       private_key 			= file(var.private_key_path)
   }

   provisioner "remote-exec" {

       connection {
           host = self.public_ip_address
           user = self.admin_username
           password = self.admin_password
       }

       # Below, we unstall some common tools, including mongo client shell
       inline = [
       "sleep 10",
       "sudo apt-get -y update",
       "sudo apt-get -y install python3-pip",
       "sudo apt-get -y update",
       "sudo pip3 install pymongo==4.0.1",
       "sudo pip3 install faker",
       "sudo pip3 install dnspython",

       "wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -",
       "echo 'deb [ arch=amd64 ] http://repo.mongodb.com/apt/ubuntu bionic/mongodb-enterprise/6.0 multiverse' | sudo tee /etc/apt/sources.list.d/mongodb-enterprise.list",
       "sudo apt-get update",
	   "sudo apt-get install -y mongodb-enterprise-shell mongodb-mongosh",

       "sudo rm -f /etc/resolv.conf ; sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf"
       ]
   }
}
