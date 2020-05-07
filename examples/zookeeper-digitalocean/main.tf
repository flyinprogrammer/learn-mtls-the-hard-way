provider "digitalocean" {
  version = "~> 1.18"
}

provider "tls" {
  version = "~> 2.1"
}

provider "template" {
  version = "~> 2.1"
}
data "template_file" "script" {
  template = file("cloudinit.sh")
}

resource "digitalocean_project" "default" {
  name        = "Zookeeper Playground"
  description = "A project for playing with Zookeeper."
  purpose     = "Class project / Educational purposes"
  environment = "development"
  resources   = flatten([digitalocean_droplet.default.*.urn])
}

resource "digitalocean_vpc" "default" {
  name        = "zookeeper-playground"
  description = "A VPC for learning Zookeeper"
  region      = var.region
  ip_range    = var.ip_range
}

resource "tls_private_key" "default" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "digitalocean_ssh_key" "default" {
  name       = "Zookeeper Playground"
  public_key = tls_private_key.default.public_key_openssh
}

resource "digitalocean_droplet" "default" {
  count      = var.instance_count
  name       = "zk-${count.index}"
  size       = "s-1vcpu-1gb"
  image      = "ubuntu-20-04-x64"
  region     = var.region
  vpc_uuid   = digitalocean_vpc.default.id
  ssh_keys   = [digitalocean_ssh_key.default.fingerprint]
  ipv6       = false
  monitoring = true
  user_data  = data.template_file.script.rendered
}
