#### Resource Groups 
resource "azurerm_resource_group" "rg01" {
  name     = var.rgne1
  location = var.locne

  tags = {
    environment = var.environment_tag
  }
}

resource "azurerm_resource_group" "rg02" {
  name     = var.rgne2
  location = var.locne

  tags = {
    environment = var.environment_tag
  }
}

#########################################################

#### Random password | Adminuser | KeyVault

resource "random_password" "dc01-vm-pass" {
  length           = 12
  lower            = true
  upper            = true
  special          = true
  override_special = "_%@"
}

resource "random_id" "rgne1-kv01" {
  byte_length = 5
  prefix      = "rgne1-kv01"
}

resource "azurerm_key_vault_secret" "vm-pass" {
  name         = "dc01-vm-pass"
  value        = random_password.dc01-vm-pass.result
  key_vault_id = azurerm_key_vault.rgne1-sec-kv01.id
  depends_on   = [azurerm_key_vault.rgne1-sec-kv01]
}

resource "azurerm_key_vault" "rgne1-sec-kv01" {
  name                        = random_id.rgne1-kv01.hex
  location                    = var.locne
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  resource_group_name         = azurerm_resource_group.rg02.name
  depends_on                  = [azurerm_resource_group.rg02]
  sku_name                    = "standard"
  enabled_for_disk_encryption = true
  purge_protection_enabled    = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    storage_permissions = ["Get", ]
    key_permissions     = ["Get", ]
    secret_permissions  = ["Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set", ]
  }
}

#########################################################

#### Virtual Network - VNET1
resource "azurerm_virtual_network" "rgne1-vnet1" {
  name                = var.rgne1-vnet1
  location            = var.locne
  resource_group_name = azurerm_resource_group.rg01.name
  address_space       = [var.rgne1-vnet1-address-space]
  dns_servers         = ["10.10.1.4", "168.63.129.16", "8.8.8.8"]
}

#### Virtual Network - SUBNET1
resource "azurerm_subnet" "rgne1-vnet1-subn1" {
  name                 = var.rgne1-vnet1-subn1-name
  address_prefixes     = [var.rgne1-vnet1-subn1-range]
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.rgne1-vnet1.name
}

#### Virtual Network - SUBNET2
resource "azurerm_subnet" "rgne1-vnet1-subn2" {
  name                 = var.rgne1-vnet1-subn2-name
  address_prefixes     = [var.rgne1-vnet1-subn2-range]
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.rgne1-vnet1.name
}
#######################################

#### Virtual Network - VNET2
resource "azurerm_virtual_network" "rgne1-vnet2" {
  name                = var.rgne1-vnet2
  location            = var.locne
  resource_group_name = azurerm_resource_group.rg01.name
  address_space       = [var.rgne1-vnet2-address-space]
}

#### Virtual Network - SUBNET1
resource "azurerm_subnet" "rgne1-vnet2-subn1" {
  name                 = var.rgne1-vnet2-subn1-name
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.rgne1-vnet2.name
  address_prefixes     = [var.rgne1-vnet2-subn1-range]
}

#### Virtual Network - SUBNET2
resource "azurerm_subnet" "rgne1-vnet2-subn2" {
  name                 = var.rgne1-vnet2-subn2-name
  resource_group_name  = azurerm_resource_group.rg01.name
  virtual_network_name = azurerm_virtual_network.rgne1-vnet2.name
  address_prefixes     = [var.rgne1-vnet2-subn2-range]
}

##############

#### Virtual Network - PEERING VNET1 --> VNET2
resource "azurerm_virtual_network_peering" "rgne1-vnet1-to-vnet2-peering" {
  name                      = var.rgne1-vnet1-to-vnet2-peering
  resource_group_name       = azurerm_resource_group.rg01.name
  virtual_network_name      = azurerm_virtual_network.rgne1-vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.rgne1-vnet2.id
  depends_on                = [azurerm_virtual_network.rgne1-vnet1]
}

#### Virtual Network - PEERING VNET2 --> VNET1
resource "azurerm_virtual_network_peering" "rgne1-vnet2-to-vnet1" {
  name                      = var.rgne1-vnet2-to-vnet1-peering
  resource_group_name       = azurerm_resource_group.rg01.name
  virtual_network_name      = azurerm_virtual_network.rgne1-vnet2.name
  remote_virtual_network_id = azurerm_virtual_network.rgne1-vnet1.id
  depends_on                = [azurerm_virtual_network.rgne1-vnet2]
}

#########################################################

#### Network - Public IP
resource "azurerm_public_ip" "rgne1-infra-pip" {
  name                = var.rgne1-infra-pip
  location            = var.locne
  resource_group_name = azurerm_resource_group.rg01.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

#### Virtual Network - Network Interface
resource "azurerm_network_interface" "nic-name" {
  name                = var.nic-name
  location            = var.locne
  resource_group_name = azurerm_resource_group.rg01.name

  ip_configuration {
    name                          = "dc01-pip"
    subnet_id                     = azurerm_subnet.rgne1-vnet1-subn1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rgne1-infra-pip.id
  }
}

#########################################################

#### Network Security Group
resource "azurerm_network_security_group" "rgne1-nsg-rdp" {
  name                = var.rgne1-nsg-rdp
  location            = var.locne
  resource_group_name = azurerm_resource_group.rg01.name

  security_rule {
    name                       = "RDP-In-Client"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "${chomp(data.http.clientip.response_body)}/32"
    destination_address_prefix = "*"
  }


  security_rule {
    name                       = "AllowPSRemoting"
    priority                   = 301
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5986"
    source_address_prefix      = "AzureActiveDirectoryDomainServices"
    destination_address_prefix = "*"
  }

}

#### Network - NSG Association 
resource "azurerm_subnet_network_security_group_association" "rgne1-vnet1-subn1-nsg" {
  subnet_id                 = azurerm_subnet.rgne1-vnet1-subn1.id
  network_security_group_id = azurerm_network_security_group.rgne1-nsg-rdp.id
}

resource "azurerm_subnet_network_security_group_association" "rgne1-vnet1-subn2-nsg" {
  subnet_id                 = azurerm_subnet.rgne1-vnet1-subn2.id
  network_security_group_id = azurerm_network_security_group.rgne1-nsg-rdp.id
}

resource "azurerm_subnet_network_security_group_association" "rgne1-vnet2-subn1-nsg" {
  subnet_id                 = azurerm_subnet.rgne1-vnet2-subn1.id
  network_security_group_id = azurerm_network_security_group.rgne1-nsg-rdp.id
}

resource "azurerm_subnet_network_security_group_association" "rgne1-vnet2-subn2-nsg" {
  subnet_id                 = azurerm_subnet.rgne1-vnet2-subn2.id
  network_security_group_id = azurerm_network_security_group.rgne1-nsg-rdp.id
}

#########################################################

#### Virtual Machine - dc01
resource "azurerm_windows_virtual_machine" "rgne1-vm01" {
  name                  = var.rgne1-vm01
  location              = var.locne
  resource_group_name   = azurerm_resource_group.rg01.name
  depends_on            = [azurerm_key_vault.rgne1-sec-kv01]
  size                  = var.vmsize-dc01
  admin_username        = var.dc01-vm-adminuser
  admin_password        = azurerm_key_vault_secret.vm-pass.value
  network_interface_ids = [azurerm_network_interface.nic-name.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}


#### NTDS Managed Disk
resource "azurerm_managed_disk" "dc01-ntds" {
  name                 = "dc01-ntds"
  location             = var.locne
  resource_group_name  = azurerm_resource_group.rg01.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "20"
  depends_on           = [azurerm_windows_virtual_machine.rgne1-vm01]

  tags = {
    environment = var.environment_tag
    Function    = "rgne1-infra-dc01-disk"
  }
}


#Attach Data Disk to Virtual Machine
resource "azurerm_virtual_machine_data_disk_attachment" "region1-dc01-data" {
  managed_disk_id    = azurerm_managed_disk.dc01-ntds.id
  depends_on         = [azurerm_windows_virtual_machine.rgne1-vm01]
  virtual_machine_id = azurerm_windows_virtual_machine.rgne1-vm01.id
  lun                = "10"
  caching            = "None"
}


#### Virtual Machine Extension PS1
resource "azurerm_virtual_machine_extension" "dc01-ad" {
  name                       = "dc01-ad-ps1"
  virtual_machine_id         = azurerm_windows_virtual_machine.rgne1-vm01.id
  depends_on                 = [azurerm_managed_disk.dc01-ntds]
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.9"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
  {
    "commandToExecute": "powershell.exe -Command \"${local.powershell}\""
  }
  SETTINGS
}

locals {
  generated_password = random_password.dc01-vm-pass.result
  cmd01              = "Get-Disk | Where partitionstyle -eq 'raw' | Initialize-Disk -PartitionStyle MBR -PassThru | New-Partition -UseMaximumSize -DriveLetter E | Format-Volume -FileSystem NTFS -NewFileSystemLabel 'data' -Confirm:$false"
  cmd02              = "Install-WindowsFeature AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools"
  cmd03              = "Install-WindowsFeature DNS -IncludeAllSubFeature -IncludeManagementTools"
  cmd04              = "Import-Module ADDSDeployment, DnsServer"
  cmd05              = "Install-ADDSForest -DomainName ${var.domain_name} -DomainNetbiosName ${var.domain_netbios_name} -DomainMode ${var.domain_mode} -ForestMode ${var.domain_mode} -DatabasePath ${var.database_path} -SysvolPath ${var.sysvol_path} -LogPath ${var.log_path} -NoRebootOnCompletion:$false -Force:$true -SafeModeAdministratorPassword (ConvertTo-SecureString ${local.generated_password} -AsPlainText -Force)"
  powershell         = "${local.cmd01}; ${local.cmd02}; ${local.cmd03}; ${local.cmd04}; ${local.cmd05}"
}

### Service Principal
resource "azuread_service_principal" "tfazspn" {
  application_id = "2565bd9d-da50-47d4-8b85-4c97f669dc36"
}

###register the Microsoft.AAD resource provider
resource "azurerm_resource_provider_registration" "tfaz-aadds" {
  name = "Microsoft.AAD"
}

####DC Admin Group | User | Password
resource "azuread_group" "dc_admins" {
  display_name     = "AAD DC Admins"
  description      = "AADDS Admins"
  members          = [azuread_user.dc_admin.object_id]
  security_enabled = true
}

resource "azuread_user" "dc_admin" {
  user_principal_name = "dc-admin@sarzali788hotmail.onmicrosoft.com"
  display_name        = "AADDS Admins"
  password            = random_password.dc_admin.result
}

resource "azuread_directory_role_assignment" "dc_admin" {
  role_id             = "62e90394-69f5-4237-9190-012177145e10" #Global Administrator built-in role ID | https://learn.microsoft.com/en-us/azure/active-directory/roles/permissions-reference#global-administrator
  principal_object_id = resource.azuread_user.dc_admin.object_id
}

resource "random_password" "dc_admin" {
  length  = 12
  lower   = true
  upper   = true
  special = true
}

resource "azurerm_key_vault_secret" "dc_admin-pass" {
  name         = "dc-admin-pass"
  value        = random_password.dc_admin.result
  key_vault_id = azurerm_key_vault.rgne1-sec-kv01.id
}

resource "azurerm_active_directory_domain_service" "tfaz-aadds" {
  name                = "aadds"
  location            = var.locne
  resource_group_name = azurerm_resource_group.rg01.name

  domain_name = "tfaz-aadds.local"
  sku         = "Standard"

  initial_replica_set {
    subnet_id = azurerm_subnet.rgne1-vnet1-subn1.id
  }

  depends_on = [
    azuread_service_principal.tfazspn,
    azurerm_resource_provider_registration.tfaz-aadds,
    azurerm_subnet_network_security_group_association.rgne1-vnet1-subn1-nsg,
  ]

}