resource "digitalocean_domain" "default" {
  name = var.domain
}

resource "digitalocean_record" "instance_public" {
  count  = var.instance_count
  domain = digitalocean_domain.default.name
  name   = "zk-${count.index + 1}"
  type   = "A"
  value  = digitalocean_droplet.default[count.index].ipv4_address
  ttl    = 300
}

resource "digitalocean_record" "instance_private" {
  count  = var.instance_count
  domain = digitalocean_domain.default.name
  name   = "zk-${count.index + 1}.private"
  type   = "A"
  value  = digitalocean_droplet.default[count.index].ipv4_address_private
  ttl    = 300
}
