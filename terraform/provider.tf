terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.42.0"
    }
  }
}

provider "proxmox" {
  endpoint = "https://192.168.50.14:8006"
  api_token = var.api_token
  insecure = true
  ssh {
    agent    = true
    username = "root"
  }
}