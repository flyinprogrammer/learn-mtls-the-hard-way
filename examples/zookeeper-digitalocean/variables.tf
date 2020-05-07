variable "region" {
  type        = string
  default     = "nyc1"
  description = "name of the region to launch resources in"
}

variable "ip_range" {
  type        = string
  default     = "10.10.20.0/24"
  description = "ip cidr block to have the instances use"
}

variable "instance_count" {
  type        = number
  default     = 3
  description = "number of zk nodes to launch"
}

variable "domain" {
  type = string
  default = "zkocean.hpy.dev"
  description = "domain to use for dns"
}