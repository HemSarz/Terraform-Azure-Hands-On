data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}

#Get Client IP Address for NSG

data "http" "clientip" {
  url = "https://ipv4.icanhazip.com/"
}