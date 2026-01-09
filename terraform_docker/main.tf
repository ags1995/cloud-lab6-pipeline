terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "ubuntu" {
  name         = "ubuntu:22.04"
  keep_locally = true
}

resource "docker_container" "lab5_server" {
  name  = "lab5-server"
  image = docker_image.ubuntu.image_id
  
  command = ["/bin/bash", "-c", "tail -f /dev/null"]
  
  ports {
    internal = 22
    external = 2222
  }
}

output "container_name" {
  value = docker_container.lab5_server.name
}
