provider "local" {
  version = "~> 1.4"
}

provider "digitalocean" {
  version = "~> 1.18"
  # you can remove this and set environment variable DIGITALOCEAN_TOKEN or DIGITALOCEAN_ACCESS_TOKEN instead
  token = yamldecode(data.local_file.doctl_config.content).access-token
}

provider "tls" {
  version = "~> 2.1"
}

provider "template" {
  version = "~> 2.1"
}
