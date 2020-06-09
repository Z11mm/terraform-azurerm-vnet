variable "vnet_name" {
  description = "Name of the vnet to create"
  default     = "acctvnet"
}

variable "resource_group_name" {
  description = "Name of the resource group to be imported."
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
  default     = ["10.0.0.0/16"]
}

# If no values specified, this defaults to Azure DNS 
variable "dns_servers" {
  description = "The DNS servers to be used with vNet."
  default     = []
}

variable "nsg_ids" {
  description = "A map of subnet name to Network Security Group IDs"
  type        = map(string)

  default = {
  }
}

variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = map(string)

  default = {
    ENV = "test"
  }
}

variable "subnets" {
  description = "List of maps containing Subnets and their inputs to be created."
  default = [{
    "name"                                           = "subnet1"
    "address_prefixes"                               = ["10.0.1.0/24"]
    "enforce_private_link_endpoint_network_policies" = false
    "enforce_private_link_service_network_policies"  = false
    "service_endpoints"                              = null
  }]
}
