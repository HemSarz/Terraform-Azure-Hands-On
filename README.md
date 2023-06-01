## Hands-On Lab – Terraform | Azure
## Infrastructure resource group
-	A Windows 2019 Virtual Machine that is promoted to Domain Controller with an attached disk used as an NTDS storage using PowerShell script within the terraform code.
-	One VNET1 with 2 subnets 
-	Peering between VNET1 and VNET2
-	Network Security Group for allowing the local machine to RDP into VM and associates the NSG rule to the subnets.
-	One Public IP for the VM DC.
-	Network Interface resource which is associated with the Public IP.

## Security Resource Group
-	Key Vault and a Secret for the admin user.
-	Creating a random password using the “Random” provider
-	VNET2 with two subnets.

## Providers:
-	Azure: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
-	Random: https://registry.terraform.io/providers/hashicorp/random/latest/docs  
