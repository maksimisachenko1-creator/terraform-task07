output "endpoint_hostname" {
  description = "The hostname of the Front Door endpoint."
  value       = azurerm_cdn_frontdoor_endpoint.fd_endpoint.host_name
}