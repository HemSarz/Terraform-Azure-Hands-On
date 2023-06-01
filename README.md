## Hands-On Lab – Terraform | Azure

## Infrastructure resource group
o	A Windows 2019 Virtual Machine that is promoted to Domain Controller with an attached disk used as an NTDS storage using PowerShell script within the terraform code.
o	One VNET1 with 2 subnets 
o	Peering between VNET1 and VNET2
o	Network Security Group for allowing the local machine to RDP into VM and associates the NSG rule to the subnets.
o	One Public IP for the VM DC.
o	Network Interface resource which is associated with the Public IP
o	Create an Admin User for the VM 

## Security Resource Group
o	Key Vault with prefix and random name using the "Random" provider
o	Creating a random password using the “Random” provider and storing it in the KeyVault as an SECRET
o	VNET2 with two subnets.

## Providers:
•	Azure: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
•	Random: https://registry.terraform.io/providers/hashicorp/random/latest/docs   
