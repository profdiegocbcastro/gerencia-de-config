resource "azurerm_linux_virtual_machine" "maquina_labs_tf" {
  name                = "maquina-labs-tf"
  resource_group_name = "meu_grupo_de_recursos" 
  location            = "East US"  
  size                = "Standard_B1s"  
  admin_username      = "adminuser" 

  network_interface_ids = [
    azurerm_network_interface.minha_placa_rede.id, 
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}