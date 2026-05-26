data "azurerm_virtual_network" "rede_existente" {
  name                = "minha-vnet"
  resource_group_name = "rg-network"
}
