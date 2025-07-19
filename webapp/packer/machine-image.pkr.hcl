packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0, < 2.0.0"
      source  = "github.com/hashicorp/amazon"
    }
    googlecompute = {
      version = ">= 1.0.0, < 2.0.0"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}

## AWS Variables
variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "source_ami" {
  type = string
}

variable "ssh_username" {
  type = string
}

variable "subnet_id" {
  type = string
}

# GCP Variables
variable "gcp_project_id" {
  type = string
}

variable "gcp_zone" {
  type    = string
  default = "us-central1-a"
}

variable "gcp_image_name" {
  type    = string
  default = "webapp-image"
}

variable "gcp_service_account_file" {
  type    = string
  default = ""
}

variable "accounts" {
  type    = list(string)
  default = []
}

variable "gcp_service_account_email" {
  type    = string
  default = null
}

# Database Variables
variable "db_password" {
  type = string
}

variable "db_name" {
  type = string
}

# AWS AMI Builder
source "amazon-ebs" "aws_image" {
  region          = var.aws_region
  ami_name        = "10_csye6225_spring_2025_app_${formatdate("YYYY_MM_DD_HH-mm", timestamp())}"
  ami_description = "AMI for CSYE 6225 Spring 2025"
  instance_type   = "t2.small"
  source_ami      = var.source_ami
  ssh_username    = var.ssh_username
  ami_users       = ["861276095817", "545009863149"]

  launch_block_device_mappings {
    delete_on_termination = true
    device_name           = "/dev/sda1"
    volume_size           = 8
    volume_type           = "gp2"
  }
}

# GCP Image Builder
source "googlecompute" "gcp_image" {
  project_id              = var.gcp_project_id
  zone                    = var.gcp_zone
  source_image_family     = "ubuntu-2204-lts"
  source_image_project_id = ["ubuntu-os-cloud"]
  machine_type            = "e2-medium"
  ssh_username            = "ubuntu"


  image_name        = "${var.gcp_image_name}-{{timestamp}}"
  image_description = "GCP Image for CSYE 6225 Spring 2025"

  image_labels = {
    name        = var.gcp_image_name
    environment = "dev"
    application = "health-check-api"
  }
}

# Common Build with Provisioners for AWS & GCP
build {
  sources = [
    "source.amazon-ebs.aws_image",
    "source.googlecompute.gcp_image"
  ]

  provisioner "shell" {
    environment_vars = [
      "DB_PASSWORD=${var.db_password}",
      "DB_NAME=${var.db_name}"
    ]
    script = "./scripts/setup.sh"
  }

  provisioner "shell" {
    script = "./scripts/local_user.sh"
  }

  provisioner "file" {
    source      = "../webapp-fork.zip"
    destination = "/tmp/webapp-fork.zip"
  }

  provisioner "shell" {
    script = "./scripts/run.sh"
  }

  provisioner "file" {
    source      = "./webapp.service"
    destination = "/tmp/webapp.service"
  }

  provisioner "shell" {
    script = "./scripts/systemd.sh"
  }
}
