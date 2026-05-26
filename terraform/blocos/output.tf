output "nome_resource_group" {
  value = azurerm_resource_group.rg.name
}

output "localizacao" {
  value = azurerm_resource_group.rg.location
}

output "id_vnet" {
  value = azurerm_virtual_network.vnet.id
}

output "enderecos_vnet" {
  value = azurerm_virtual_network.vnet.address_space
}