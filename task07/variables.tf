variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be created."
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account."
}

variable "fd_profile_name" {
  type        = string
  description = "The name of the Front Door profile."
}

variable "fd_profile_sku" {
  type        = string
  description = "The SKU of the Front Door profile."
}

variable "fd_endpoint_name" {
  type        = string
  description = "The name of the Front Door endpoint."
}

variable "fd_origin_group_name" {
  type        = string
  description = "The name of the Front Door origin group."
}

variable "fd_origin_name" {
  type        = string
  description = "The name of the Front Door origin."
}

variable "fd_route_name" {
  type        = string
  description = "The name of the Front Door route."
}