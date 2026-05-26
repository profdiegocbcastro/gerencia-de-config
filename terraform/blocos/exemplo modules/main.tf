module "rede" {
  source = "./modules/network"

  nome_rg = "rg-exemplo"
  regiao  = "Brazil South"
}