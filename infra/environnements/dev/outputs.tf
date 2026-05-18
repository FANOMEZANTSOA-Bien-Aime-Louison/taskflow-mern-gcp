output "vpc_name" {
  value = module.network.vpc_name
}

output "subnet_name" {
  value = module.network.subnet_name
}

output "frontend_ip" {
  value       = module.frontend_storage.frontend_ip
  description = "IP du Load Balancer frontend à mettre dans Cloudflare"
}
