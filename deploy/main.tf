terraform {
  required_providers {
    env = {
      source = "tchupp/env"
      version = "0.0.2"
    }
    docker = {
      source = "kreuzwerker/docker"
      version = "2.15.0"
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
  name = data.env_variable.image_name
}

# Create a container
resource "docker_container" "stack" {
  image = docker_image.aims.latest
  name  = "web"
}
