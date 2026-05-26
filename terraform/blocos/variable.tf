variable "regiao" {
  type        = string
  default     = "Brazil South"
  description = "Região da Azure"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-exemplo"
  location = var.regiao
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-exemplo"
  location            = var.regiao
  resource_group_name = azurerm_resource_group.rg.name

  address_space = ["10.0.0.0/16"]
}