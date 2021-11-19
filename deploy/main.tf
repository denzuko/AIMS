terraform {
  required_providers {
    env = {
      source = "tchupp/env"
    }
    docker = {
      source = "kreuzwerker/docker"
    }      
  }
}

provider "docker" {
  version = "~> 2.15.0"
}

provider "env" {
  version = "~> 0.0.2"
}

data "env_variable" "image_name" {
  name = "IMAGE_NAME"
}

# Pulls the image
resource "docker_image" "aims" {
  name = data.env_variable.image_name.value
}

# Create a container
resource "docker_container" "stack" {
  image = docker_image.aims.latest
  name  = "web"
}
