resource "digitalocean_domain" "default" {
  name = var.domain
}

resource "digitalocean_record" "instance_public" {
  count = var.instance_count
  domain = digitalocean_domain.default.name
  name = "zk-${count.index}"
  type = "A"
  value = digitalocean_droplet.default[count.index].ipv4_address
}

resource "digitalocean_record" "instance_private" {
  count = var.instance_count
  domain = digitalocean_domain.default.name
  name = "zk-${count.index}.private"
  type = "A"
  value = digitalocean_droplet.default[count.index].ipv4_address_private
}

