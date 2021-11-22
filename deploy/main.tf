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

resource "random_string" "random" {
  count            = 2
  length           = 4
  special          = false
  upper            = false
}

# Pulls the image
resource "docker_image" "aims" {
  name = data.env_variable.image_name.value
}

resource "docker_image" "mongodb" {
  name = "mongo:latest"
}

resource "docker_image" "redis" {
  name = "redis:latest"
}
# Create networks

resource "docker_network" "default" {
  name   = "public"
  driver = "bridge"
}

resource "docker_network" "internal" {
  name     = "internal"
  driver   = "bridge"
  internal = true
}

# Create volumes
resource "docker_volume" "mongo_volume" {
  name = "mongodata"
}

resource "docker_volume" "redis_volume" {
  name = "redisdata"
}

# Create a container
resource "docker_container" "cache" {
  image = docker_image.redis.latest
  name  = join("-",["api",random_string.random[count.index].result])
  count = 1

  port {
      internal = "6379/tcp"
  }

  volumes {
    volume_name    = "${docker_volume.redis_volume.name}"
    container_path = "/data/db/redis"
  }

  networks_advanced {
    name    = "${docker_network.internal.name}"
    aliases = ["redis"]
  }
  
  labels {
    label = "org.label-schema.vendor"
    value = "denzuko"
  }

  labels {
    label = "org.label-schema.url"
    value = "https://dwightaspencer.com"
  }

  labels {
    label = "org.label-schema.name"
    value = "aims"
  }

  labels {
    label = "org.label-schema.description"
    value = "ansible inventory management system"
  }
  
  labels {
    labels = "org.label-schema.version"
    value = "1.0.0"
  }

  labels {
    label = "org.label-schema.vcs-url"
    value = "https://github.com/denzuko/AIMS"
  }

  labels {
    label = "org.label-schema.vcs-ref"
    value = "master"
  }
  
  labels {
    label = "org.label-schema.docker.schema-version" 
    value = "1.0"
  }
  
  labels {
    label = "com.dwightaspencer.role"
    value = "cmdb"
  }
  
  labels {
    label = "com.dwightaspencer.owner"
    value = "INT-01"
  }
}

resource "docker_container" "database" {
  image = docker_image.mongodb.latest
  name  = join("-",["api",random_string.random[count.index].result])
  count = 2

  port {
      internal = "27017/tcp"
  }

  networks_advanced {
    name    = "${docker_network.internal.name}"
    aliases = ["mongo"]
  }  

  volumes {
    volume_name    = docker_volume.mongo_volume.name
    container_path = "/data/db/mongo"
  }
  
  labels {
    label = "org.label-schema.vendor"
    value = "denzuko"
  }

  labels {
    label = "org.label-schema.url"
    value = "https://dwightaspencer.com"
  }

  labels {
    label = "org.label-schema.name"
    value = "aims"
  }

  labels {
    label = "org.label-schema.description"
    value = "ansible inventory management system"
  }
  
  labels {
    labels = "org.label-schema.version"
    value = "1.0.0"
  }

  labels {
    label = "org.label-schema.vcs-url"
    value = "https://github.com/denzuko/AIMS"
  }

  labels {
    label = "org.label-schema.vcs-ref"
    value = "master"
  }
  
  labels {
    label = "org.label-schema.docker.schema-version" 
    value = "1.0"
  }
  
  labels {
    label = "com.dwightaspencer.role"
    value = "cmdb"
  }
  
  labels {
    label = "com.dwightaspencer.owner"
    value = "INT-01"
  }
}

resource "docker_container" "api" {
  image = docker_image.aims.latest
  name  = join("-",["api",random_string.random[count.index].result])
  count = 2

  port {
      internal = "8080/tcp"
  }

  networks_advanced {
    name    = "${docker_network.internal.name}"
  }

  networks_advanced {
    name    = "${docker_network.default.name}"
  }

  depends_on = ["docker_container.cache", "docker_container.database"]
  
  labels {
    label = "org.label-schema.vendor"
    value = "denzuko"
  }

  labels {
    label = "org.label-schema.url"
    value = "https://dwightaspencer.com"
  }

  labels {
    label = "org.label-schema.name"
    value = "aims"
  }

  labels {
    label = "org.label-schema.description"
    value = "ansible inventory management system"
  }
  
  labels {
    labels = "org.label-schema.version"
    value = "1.0.0"
  }

  labels {
    label = "org.label-schema.vcs-url"
    value = "https://github.com/denzuko/AIMS"
  }

  labels {
    label = "org.label-schema.vcs-ref"
    value = "master"
  }
  
  labels {
    label = "org.label-schema.docker.schema-version" 
    value = "1.0"
  }
  
  labels {
    label = "com.dwightaspencer.role"
    value = "cmdb"
  }
  
  labels {
    label = "com.dwightaspencer.owner"
    value = "INT-01"
  }
}
