output "public_ip_address1" {
  description = "Public IP of azure VM"
  value       = module.azure-west.public_ip_address
}

output "public_ip_address2" {
  description = "Public IP of azure VM"
  value       =  module.azure-north.public_ip_address
}

output "public_ip_address3" {
  description = "Public IP of azure VM"
  value       = module.azure-central.public_ip_address
}

output "atlasclusterstring" {
  value = module.atlas.atlasclusterstring
}

output "user1" {
  value = module.atlas.user1
}