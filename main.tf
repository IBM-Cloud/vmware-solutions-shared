# Configure the VMware vCloud Director Provider
provider "vcd" {
  user     = var.vcd_user
  password = var.vcd_password
  org      = var.vcd_org
  url      = var.vcd_url
  vdc      = var.vdc_name
}

# Used to obtain information from the already deployed Edge Gateway
module ibm_vmware_solutions_shared_instance {
  source = "./modules/ibm-vmware-solutions-shared-instance/"

  vdc_edge_gateway_name = var.vdc_edge_gateway_name
}

# Create a routed network
resource "vcd_network_routed" "tutorial_network" {

  name         = "Tutorial-Network"
  edge_gateway = module.ibm_vmware_solutions_shared_instance.edge_gateway_name
  gateway      = "192.168.100.1"

  interface_type = "distributed"

  static_ip_pool {
    start_address = "192.168.100.5"
    end_address   = "192.168.100.254"
  }

  dns1 = "9.9.9.9"
  dns2 = "1.1.1.1"
}

# Create the firewall rule to access the Internet 
resource "vcd_nsxv_firewall_rule" "rule_internet" {
  edge_gateway = module.ibm_vmware_solutions_shared_instance.edge_gateway_name
  name         = "${vcd_network_routed.tutorial_network.name}-Internet"

  action = "accept"

  source {
    org_networks = [vcd_network_routed.tutorial_network.name]
  }

  destination {
    ip_addresses = []
  }

  service {
    protocol = "any"
  }
}

# Create SNAT rule to access the Internet
resource "vcd_nsxv_snat" "rule_internet" {
  edge_gateway = module.ibm_vmware_solutions_shared_instance.edge_gateway_name
  network_type = "ext"
  network_name = module.ibm_vmware_solutions_shared_instance.external_network_name_2

  original_address   = "${vcd_network_routed.tutorial_network.gateway}/24"
  translated_address = module.ibm_vmware_solutions_shared_instance.default_external_network_ip
}

# Create the firewall rule to allow SSH from the Internet
resource "vcd_nsxv_firewall_rule" "rule_internet_ssh" {
  count = tobool(var.allow_ssh) == true ? 1 :0

  edge_gateway = module.ibm_vmware_solutions_shared_instance.edge_gateway_name
  name         = "${vcd_network_routed.tutorial_network.name}-Internet-SSH"

  action = "accept"

  source {
    ip_addresses = []
  }

  destination {
    ip_addresses = [module.ibm_vmware_solutions_shared_instance.default_external_network_ip]
  }

  service {
    protocol = "tcp"
    port     = 22
  }
}

# Create DNAT rule to allow SSH from the Internet
resource "vcd_nsxv_dnat" "rule_internet_ssh" {
  count = tobool(var.allow_ssh) == true ? 1 :0

  edge_gateway = module.ibm_vmware_solutions_shared_instance.edge_gateway_name
  network_type = "ext"
  network_name = module.ibm_vmware_solutions_shared_instance.external_network_name_2

  original_address = module.ibm_vmware_solutions_shared_instance.default_external_network_ip
  original_port    = 22

  translated_address = vcd_vapp_vm.vm_1.network[0].ip
  translated_port    = 22
  protocol           = "tcp"
}

# Create the firewall to access IBM Cloud services over the IBM Cloud private network 
resource "vcd_nsxv_firewall_rule" "rule_ibm_private" {
  edge_gateway = module.ibm_vmware_solutions_shared_instance.edge_gateway_name
  name         = "${vcd_network_routed.tutorial_network.name}-IBM-Private"

  logging_enabled = "false"
  action          = "accept"

  source {
    org_networks = [vcd_network_routed.tutorial_network.name]
  }

  destination {
    gateway_interfaces = [module.ibm_vmware_solutions_shared_instance.external_network_name_1]
  }

  service {
    protocol = "any"
  }
}

# Create SNAT rule to access the IBM Cloud services over a private network
resource "vcd_nsxv_snat" "rule_ibm_private" {
  edge_gateway = module.ibm_vmware_solutions_shared_instance.edge_gateway_name
  network_type = "ext"
  network_name = module.ibm_vmware_solutions_shared_instance.external_network_name_1

  original_address   = "${vcd_network_routed.tutorial_network.gateway}/24"
  translated_address = module.ibm_vmware_solutions_shared_instance.external_network_ips_2
}

# Create vcd App
resource "vcd_vapp" "vmware_tutorial_vapp" {
  name = "vmware-tutorial-vApp"
}

# Connect org Network to vcpApp
resource "vcd_vapp_org_network" "tutorial_network" {
  vapp_name        = vcd_vapp.vmware_tutorial_vapp.name
  org_network_name = vcd_network_routed.tutorial_network.name
}

# Create VM
resource "vcd_vapp_vm" "vm_1" {
  vapp_name     = vcd_vapp.vmware_tutorial_vapp.name
  name          = "vm-centos8-01"
  catalog_name  = "Public Catalog"
  template_name = "CentOS-8-Template-Official"
  memory        = 8192
  cpus          = 2

  guest_properties = {
    "guest.hostname" = "vm-centos8-01"
  }

  network {
    type               = "org"
    name               = vcd_vapp_org_network.tutorial_network.org_network_name
    ip_allocation_mode = "POOL"
    is_primary         = true
  }

  customization {
    auto_generate_password     = false
    admin_password             = "test"
  }
}
