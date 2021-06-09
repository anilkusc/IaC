provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aks" {
  name     = "${var.ENVIRONMENT}-aks-${var.PROJECT}-${var.PROJECT_CODE}-${var.LOCATION_CODE}"
  location = var.LOCATION
}
resource "azurerm_virtual_network" "vnet" {
 name                = "spoke-${var.ENVIRONMENT}-${var.PROJECT}-${var.PROJECT_CODE}-${var.LOCATION_CODE}"
 location            = azurerm_resource_group.aks.location
 resource_group_name = azurerm_resource_group.aks.name
 address_space       = ["${var.PROJ_VNET_ADDRESS_SPACE_1}","${var.PROJ_VNET_ADDRESS_SPACE_2}"]
} 

resource "azurerm_subnet" "subnet1" {
  name = "${var.ENVIRONMENT}-aks"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.AKS_SUBNET_IP_PREFIX]
}

resource "azurerm_subnet" "subnet2" {
  name = "${var.ENVIRONMENT}-external"
  resource_group_name = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = [var.SVC_SUBNET_IP_PREFIX]  
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.ENVIRONMENT}-aks-${var.PROJECT_CODE}-${var.LOCATION_CODE}-pip"
  resource_group_name = azurerm_resource_group.aks.name
  location            = azurerm_resource_group.aks.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_kubernetes_cluster" "development" {
  name                = "${var.ENVIRONMENT}-aks-${var.PROJECT}-${var.PROJECT_CODE}-${var.LOCATION_CODE}"
  kubernetes_version  = var.AKS_VERSION
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  node_resource_group = "${var.ENVIRONMENT}-node-${var.PROJECT}-${var.PROJECT_CODE}-${var.LOCATION_CODE}"
  dns_prefix          = "${var.ENVIRONMENT}-dns-prefix-${var.LOCATION_CODE}"
  default_node_pool {
    name                = var.AKS_DEFAULT_NODEPOOL
    node_count          = 1
    vm_size             = "Standard_DS2_v2"
    max_pods            = 50
    vnet_subnet_id      = azurerm_subnet.subnet1.id
    node_labels         = { app = "system" }
  }
  network_profile {
    docker_bridge_cidr       = var.AKS_DOCKER_BRIDGE_ADDRESS
    dns_service_ip           = var.AKS_DNS_SERVICE_IP
    network_plugin           = "azure"
    network_mode             = "transparent"
    service_cidr             = var.AKS_SERVICE_CIDR
    load_balancer_profile { 
      outbound_ip_address_ids = [azurerm_public_ip.pip.id]
    }
  }
    service_principal {
    client_id     = var.CLIENT_ID
    client_secret = var.CLIENT_SECRET
  }

}

resource "azurerm_kubernetes_cluster_node_pool" "first" {
  name                  = "app"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.development.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1
  max_pods              = 50
  vnet_subnet_id        = azurerm_subnet.subnet1.id
  node_labels           = { app = "app" }
}
