##Hands-On Lab Environment for Azure

##The following resources are deployed:

    Two Resource Groups, one for the Lab infrastructure, and another for Security related items.
    Two Subnets in each VNET with peering
    Uses the Automatic-ClientIP-NSG to setup a Network Security Group that allows RDP access in - this NSG rule uses the external IP of the machine that runs Terraform.
    Associates the created NSG to all Lab Subnets.
    Creates a Key Vault with a randomised name, using Azure-KeyVault-with-Secret, and then creates a password as a Secret within the Key Vault that is used later to setup a VM.
    Creates a Public IP for the Domain Controller VM.
    Creates a Network Interface Card and associates the above Public IP.
    Creates a Data Disk for NTDS Storage on the Domain Controller VM.
    Creates a Windows 2019 VM to act as a Domain Controller. The Username for this VM is a Variable, and the Password is saved as a Secret in the Key Vault. (It was automatically generated in Step 6).
    Attaches the Data Disk created
