output "ssh_key" {
  value = tls_private_key.default.private_key_pem
}

output "dns" {
  value = digitalocean_domain.default.id
}
