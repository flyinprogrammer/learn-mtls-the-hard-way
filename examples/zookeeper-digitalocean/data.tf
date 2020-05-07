# https://github.com/terraform-providers/terraform-provider-digitalocean/issues/259
data "local_file" "doctl_config" {
  # this is linux specific
  filename = pathexpand("~/.config/doctl/config.yaml")
  # this is for macos
  # filename = pathexpand("~/Library/Application\ Support/doctl/config.yaml"
}

data "template_file" "script" {
  template = file("cloudinit.sh")

  vars = {
    domain = var.domain
  }
}
