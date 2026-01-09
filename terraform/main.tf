terraform {
  required_version = ">= 1.0.0"

  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.48.0" # Use the version you manually installed
    }
  }
}

provider "openstack" {
  auth_url    = "https://cloud.crplab.ru:5000/v3"
  region      = "RegionOne"
  user_name   = "master2022"
  password    = "J8F3LGa*7KU7ye"
  tenant_name = "students"
  domain_name = "Default"
}

# Create a security group
resource "openstack_networking_secgroup_v2" "lab_secgroup" {
  name        = "lab5-security-group"
  description = "Security group for Lab 5"
}

resource "openstack_networking_secgroup_rule_v2" "ssh_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.lab_secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "http_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8080
  port_range_max    = 8080
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.lab_secgroup.id
}

# Create the instance (using variables from terraform.tfvars)
resource "openstack_compute_instance_v2" "lab5_server" {
  name            = "lab5-server"
  image_name      = var.image_name
  flavor_name     = var.flavor_name
  security_groups = [openstack_networking_secgroup_v2.lab_secgroup.name]

  network {
    name = var.network_name
  }

  # This will be used for Ansible connection later
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.access_ip_v4
  }
}

# Output the instance IP
output "instance_ip" {
  value       = openstack_compute_instance_v2.lab5_server.access_ip_v4
  description = "Public IP of the created instance"
}
