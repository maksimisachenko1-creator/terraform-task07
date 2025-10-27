resource "azurerm_cdn_frontdoor_profile" "fd_profile" {
  name                = var.profile_name
  resource_group_name = var.resource_group_name
  sku_name            = var.profile_sku
}

resource "azurerm_cdn_frontdoor_endpoint" "fd_endpoint" {
  name                     = var.endpoint_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
}

resource "azurerm_cdn_frontdoor_origin_group" "fd_origin_group" {
  name                     = var.origin_group_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
  session_affinity_enabled = true

  load_balancing {}
}

resource "azurerm_cdn_frontdoor_origin" "fd_origin" {
  name                           = var.origin_name
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.fd_origin_group.id
  enabled                        = true
  host_name                      = var.origin_hostname
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = var.origin_hostname
  certificate_name_check_enabled = false
}

resource "azurerm_cdn_frontdoor_route" "fd_route" {
  name                          = var.route_name
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.fd_origin.id]
  supported_protocols           = ["Http", "Https"]
  patterns_to_match             = ["/*"]
  forwarding_protocol           = "MatchRequest"
}