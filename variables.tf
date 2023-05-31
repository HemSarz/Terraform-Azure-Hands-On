variable "rgne1" {
  type        = string
  description = "ResourceGroupInfra"
}

variable "rgne2" {
  type        = string
  description = "ResourceGroupSec"
}

variable "locne" {
  type        = string
  description = "Default location used"
}

variable "environment_tag" {
  type        = string
  description = "Type Of environment"
}

variable "rgne1-vnet1-to-vnet2-peering" {
  type        = string
  description = "Peering Between VNETS"
}

variable "rgne1-vnet2-to-vnet1-peering" {
  type        = string
  description = "Peering Between VNETS"
}

variable "rgne1-vnet1" {
  type        = string
  description = "VNET1 Name"
}

variable "rgne1-vnet2" {
  type        = string
  description = "VNET2 Name"
}

variable "rgne1-vnet1-subn1-name" {
  type        = string
  description = "Subnet1 name"
}

variable "rgne1-vnet1-subn2-name" {
  type        = string
  description = "Subnet2 name"
}

variable "rgne1-vnet1-subn1-range" {
  type        = string
  description = "IP Range Subnet1"
}

variable "rgne1-vnet1-subn2-range" {
  type        = string
  description = "IP Range Subnet2"
}

variable "rgne1-vnet2-subn1-name" {
  type        = string
  description = "VNET2 Subnet1 name"
}

variable "rgne1-vnet2-subn2-name" {
  type        = string
  description = "VNET2 Subnet2 name"
}

variable "rgne1-vnet2-subn1-range" {
  type        = string
  description = "VNTE2 Subnet1 IP Range"
}

variable "rgne1-vnet2-subn2-range" {
  type        = string
  description = "VNTE2 Subnet2 IP Range"
}

variable "rgne1-vnet1-address-space" {
  type        = string
  description = "VNET1 Address space"
}

variable "rgne1-vnet2-address-space" {
  type        = string
  description = "VNET2 Address range"
}

variable "rgne1-nsg-rdp" {
  type        = string
  description = "RDP Rule"
}

variable "rgne1-infra-pip" {
  type        = string
  description = "PIP DC01"
}

variable "nic-name" {
  type        = string
  description = "Name of NIC"
}

variable "rgne1-vm01" {
  type        = string
  description = "name used for VM"
}

variable "vmsize-dc01" {
  type        = string
  description = "VM size Domain Controller"
}

variable "dc01-vm-adminuser" {
  type        = string
  description = "VM User"
}

#####################

variable "domain_name" {
  type    = string
  default = "tfaz.local"
}


variable "domain_netbios_name" {
  type    = string
  default = "tfaz"
}

variable "domain_mode" {
  type    = string
  default = "WinThreshold" # Windows Server 2016 mode
}

variable "database_path" {
  type    = string
  default = "E:/Windows/NTDS"
}

variable "sysvol_path" {
  type    = string
  default = "E:/Windows/SYSVOL"
}

variable "log_path" {
  type    = string
  default = "E:/Windows/NTDS"
}