variable "auth_url" {
  description = "OpenStack authentication URL"
  type        = string
}

variable "region" {
  description = "OpenStack region"
  type        = string
}

variable "user_name" {
  description = "OpenStack username"
  type        = string
}

variable "password" {
  description = "OpenStack password"
  type        = string
  sensitive   = true
}

variable "tenant_name" {
  description = "OpenStack tenant/project name"
  type        = string
}

variable "domain_name" {
  description = "OpenStack domain name"
  type        = string
  default     = "Default"
}

variable "image_name" {
  description = "Image name for the instance"
  type        = string
}

variable "flavor_name" {
  description = "Flavor name for the instance"
  type        = string
}

variable "network_name" {
  description = "Network name for the instance"
  type        = string
}
