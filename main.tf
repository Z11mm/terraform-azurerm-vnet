#Azure Generic vNet Module
data "azurerm_resource_group" "vnet" {
  name = var.resource_group_name
}


resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.vnet.name
  location            = data.azurerm_resource_group.vnet.location
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  count                                          = length(var.subnets)
  name                                           = var.subnets[count.index]["name"]
  resource_group_name                            = data.azurerm_resource_group.vnet.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = lookup(var.subnets[count.index], "address_prefixes", ["10.0.1.0/24"])
  service_endpoints                              = lookup(var.subnets[count.index], "service_endpoints", null)
  enforce_private_link_endpoint_network_policies = lookup(var.subnets[count.index], "enforce_private_link_endpoint_network_policies", false)
  enforce_private_link_service_network_policies  = lookup(var.subnets[count.index], "enforce_private_link_service_network_policies", false)
}

data "azurerm_subnet" "import" {
  for_each             = var.nsg_ids
  name                 = each.key
  resource_group_name  = data.azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  depends_on = [azurerm_subnet.subnet]
}

resource "azurerm_subnet_network_security_group_association" "vnet" {
  for_each                  = var.nsg_ids
  subnet_id                 = data.azurerm_subnet.import[each.key].id
  network_security_group_id = each.value

  depends_on = [data.azurerm_subnet.import]
}
