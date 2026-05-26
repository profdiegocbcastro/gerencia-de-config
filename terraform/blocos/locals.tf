locals {
  nome_empresa = "cefet"
  ambiente     = "dev"

  nome_rg = "${local.nome_empresa}-${local.ambiente}-rg"
}

resource "azurerm_resource_group" "rg" {
  name     = local.nome_rg
  location = "Brazil South"
}