# Variables provider.tf 
variable "api_token" {
    description = "Token de connexion API Proxmox" 
    type = string 
    default = "Anais@pve!terraform=8604ec66-b9c0-4097-9671-3b9cbde30e24"
}

# Variables main.tf
variable "target_node" {
    description = "Nom du noeud Proxmox" 
    type = string 
    default = "pve1"
}

variable "datastore" {
    description = "Datastore" 
    type = string 
    default = "local-lvm"
}

variable "disk_interface" {
    description = "Interface disque" 
    type = string 
    default = "scsi0"
}

variable "username_default" {
    description = "Nom de l'utilisateur par défaut" 
    type = string 
    default = "anais"
}

variable "password_default" {
    description = "Mot de passe par défaut" 
    type = string 
    default = "anais"
}

variable "net_interface" {
    description = "Interface réseau" 
    type = string 
    default = "vmbr0"
}
