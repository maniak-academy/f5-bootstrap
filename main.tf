terraform {
  required_providers {
    bigip = {
      source  = "F5Networks/bigip"
      version = "1.13.1"
    }
  }
}


provider "bigip" {
  address  = var.bigipmgmt
  username = var.bigipmgmtuser
  password = var.bigippass
}





// Using  provisioner to download and install do rpm on bigip, pass arguments as BIG-IP IP address, credentials 
// Use this provisioner for first time to download and install do rpm on bigip

resource "null_resource" "install_do" {
  provisioner "local-exec" {
    command = "./install-do-rpm.sh ${var.bigipmgmt} ${var.bigipmgmtuser}:${var.bigippass}"
  }
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [null_resource.install_do]
  create_duration = "15s"
}

resource "null_resource" "install_as3" {
  provisioner "local-exec" {
    command = "./install-as3-rpm.sh ${var.bigipmgmt} ${var.bigipmgmtuser}:${var.bigippass}"
  }
}