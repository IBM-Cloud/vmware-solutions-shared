terraform {
  required_version = ">= 1.1.8"
  required_providers {
    vcd = {
      source = "vmware/vcd"
      version = ">= 3.6.0"
    }
  }
}
