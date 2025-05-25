# Création de la VM SRV-Gitlab
resource "proxmox_virtual_environment_vm" "SRV-Gitlab" {
  name            = "SRV-Gitlab"
  node_name       = var.target_node
  vm_id           = 0102

  clone {
    vm_id         = 9001
  }
  agent {
    enabled       = true
  } 
   cpu {
    cores         = 4
  }
  memory {
    dedicated     = 4096
  } 
  disk {
    datastore_id  = var.datastore
    interface     = var.disk_interface
    size          = 20
  } 
 
  initialization {
    datastore_id  = var.datastore
    user_account {
        username = var.username_default
        password = var.password_default
        keys = [file("~/.ssh/id_ed25519.pub")]
    } 
    ip_config {
        ipv4 {
            address = "192.168.50.230/24"
            gateway = "192.168.50.254"
        } 
    } 
  }

  keyboard_layout = "fr"
  
  network_device {
    bridge = var.net_interface
  } 
}

# Suppression des anciennes données SSH
resource "null_resource" "Delete_SSH" {
  provisioner "local-exec" {
    command = "ssh-keygen -f /home/bootstrap/.ssh/known_hosts -R 192.168.50.230"
  }
  depends_on = [
    proxmox_virtual_environment_vm.SRV-Gitlab
  ]
}

# Appliquer le playbook Ansible pour Gitlab
resource "null_resource" "Playbook_Ansible" {
  provisioner "local-exec" {
    command = "sleep 15"
  }
  provisioner "local-exec" {
    command = "ansible-playbook /home/bootstrap/projet/ansible/playbooks/gitlab_install.yml"
  }
  depends_on = [
    null_resource.Delete_SSH
  ]
}




# Création de la VM SRV-Keycloak
resource "proxmox_virtual_environment_vm" "SRV-Keycloak" {
  name            = "SRV-Keycloak"
  node_name       = var.target_node
  vm_id           = 0103

  clone {
    vm_id         = 9001
  }
  agent {
    enabled       = true
  } 
   cpu {
    cores         = 4
  }
  memory {
    dedicated     = 4096
  } 
  disk {
    datastore_id  = var.datastore
    interface     = var.disk_interface
    size          = 20
  } 
 
  initialization {
    datastore_id  = var.datastore
    user_account {
        username = var.username_default
        password = var.password_default
        keys = [file("~/.ssh/id_ed25519.pub")]
    } 
    ip_config {
        ipv4 {
            address = "192.168.50.231/24"
            gateway = "192.168.50.254"
        } 
    } 
  }

  keyboard_layout = "fr"
  
  network_device {
    bridge = var.net_interface
  } 
  depends_on = [
    null_resource.Playbook_Ansible
  ]
}

# Suppression des anciennes données SSH
resource "null_resource" "Delete_SSH_V2" {
  provisioner "local-exec" {
    command = "ssh-keygen -f /home/bootstrap/.ssh/known_hosts -R 192.168.50.231"
  }
  depends_on = [
    proxmox_virtual_environment_vm.SRV-Keycloak
  ]
}


# Appliquer le playbook Ansible
resource "null_resource" "Playbook_Ansible_V2" {
  provisioner "local-exec" {
    command = "sleep 15"
  }
  provisioner "local-exec" {
    command = "ansible-playbook /home/bootstrap/projet/ansible/playbooks/keycloack_install.yml"
  }
  depends_on = [
    null_resource.Delete_SSH_V2
  ]
}

# Appliquer le playbook OIDC
resource "null_resource" "Playbook_OIDC" {
  provisioner "local-exec" {
    command = "sleep 15"
  }
  provisioner "local-exec" {
    command = "ansible-playbook /home/bootstrap/projet/ansible/playbooks/oidc.yml"
  }
  depends_on = [
    null_resource.Playbook_Ansible_V2
  ]
}



# Création de la VM SRV-Apache
#resource "proxmox_virtual_environment_vm" "SRV-Apache" {
#  name            = "SRV-Apache"
#  node_name       = var.target_node
#  vm_id           = 0104
#
#  clone {
#    vm_id         = 9001
#  }
#  agent {
#    enabled       = true
#  } 
#   cpu {
#    cores         = 4
#  }
#  memory {
#    dedicated     = 4096
#  } 
#  disk {
#    datastore_id  = var.datastore
#    interface     = var.disk_interface
#    size          = 20
#  } 
# 
#  initialization {
#    datastore_id  = var.datastore
#    user_account {
#        username = var.username_default
#        password = var.password_default
#        keys = [file("~/.ssh/id_ed25519.pub")]
#    } 
#    ip_config {
#        ipv4 {
#            address = "192.168.50.232/24"
#            gateway = "192.168.50.254"
#        } 
#    } 
#  }
#
#  keyboard_layout = "fr"
#  
#  network_device {
#    bridge = var.net_interface
#  } 
#  depends_on = [
#    null_resource.Playbook_OIDC
#  ]
#}

# Suppression des anciennes données SSH
#resource "null_resource" "Delete_SSH_V3" {
#  provisioner "local-exec" {
#    command = "ssh-keygen -f /home/bootstrap/.ssh/known_hosts -R 192.168.50.232"
#  }
#  depends_on = [
#    proxmox_virtual_environment_vm.SRV-Apache
#  ]
#}

# Appliquer le playbook Apache
# resource "null_resource" "Playbook_Apache" {
#  provisioner "local-exec" {
#    command = "sleep 15"
#  }
#  provisioner "local-exec" {
#    command = "ansible-playbook /home/bootstrap/projet/ansible/playbooks/apache_install.yml"
#  }
#  depends_on = [
#    null_resource.Delete_SSH_V3
#  ]
#}
