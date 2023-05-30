####ResourceGroupVB

rgne1 = "rgtfaz-infra"
rgne2 = "rgtfaz-sec"

####Region/Env

environment_tag = "tfaz-dev"
locne           = "norwayeast"

####VNET1/SUBNET1

rgne1-vnet1                  = "tfaz-vnet1-infra"
rgne1-vnet1-address-space    = "10.10.0.0/16"
rgne1-vnet1-subn1-name       = "tfaz-vnet1-subn1"
rgne1-vnet1-subn2-name       = "tfaz-vnet1-subn2"
rgne1-vnet1-subn1-range      = "10.10.1.0/24"
rgne1-vnet1-subn2-range      = "10.10.2.0/24"
rgne1-vnet1-to-vnet2-peering = "rgne1-vnet1-to-rgne1-vnet2"

####VNET2/SUBNET2

rgne1-vnet2                  = "tfaz-vnet2-sec"
rgne1-vnet2-address-space    = "10.11.0.0/16"
rgne1-vnet2-subn1-name       = "tfaz-vnet2-subn1"
rgne1-vnet2-subn2-name       = "tfaz-vnet2-subn2"
rgne1-vnet2-subn1-range      = "10.11.1.0/24"
rgne1-vnet2-subn2-range      = "10.11.2.0/24"
rgne1-vnet2-to-vnet1-peering = "rgne1-vnet2-to-rgne1-vnet1"

####PIP

rgne1-infra-pip = "pip-dc01"

#####NSG 

rgne1-nsg-rdp = "ClientRDPIn"

####VM

vmsize-dc01 = "Standard_D2s_v4"
rgne1-vm01  = "dc01-tfaz-rg1"
nic-name    = "tfaz-dc01-nic01"

#### AdminUser
dc01-vm-adminuser = "dc01-admin"