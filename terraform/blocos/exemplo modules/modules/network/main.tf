resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-modulo"
  location            = var.regiao
  resource_group_name = var.nome_rg

  address_space = ["10.0.0.0/16"]
}