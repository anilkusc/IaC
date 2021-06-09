ENVIRONMENT                 = "dev"
LOCATION                    = "westeurope"
LOCATION_CODE               = "weu"
PROJECT                     = "anilkuscu"
PROJECT_CODE                = "ak"
PROJ_VNET_ADDRESS_SPACE_1   = "10.165.80.0/21"
PROJ_VNET_ADDRESS_SPACE_2   = "10.165.88.0/21"
# it can be same as address space 1
AKS_SUBNET_IP_PREFIX        = "10.165.80.0/21"
# it can be last 24 subnet of address space 2. 88+8 = 96
SVC_SUBNET_IP_PREFIX        = "10.165.96.0/24"
AKS_DEFAULT_NODEPOOL        = "primary"
# it can be static
AKS_SERVICE_CIDR            = "10.41.0.0/16"
TENANT_ID                   = "<Your tenant id>" # az account show | jq -r .tenantId
SUBSCRIPTION_ID             = "<Your subscription id>" # az account show | jq -r .id
AKS_VERSION                 = "1.19.11"
# it can be static
AKS_DOCKER_BRIDGE_ADDRESS   = "172.17.0.1/16"
# it can be static
AKS_DNS_SERVICE_IP          = "10.41.0.10"
# AAD -> App regsitrations -> new registration (Service principal)
CLIENT_ID                   = "<Client id of sp.It can be found on overwiew>"
CLIENT_SECRET               = "<Client Secret of sp.It can be found on certificates & secrets>"
