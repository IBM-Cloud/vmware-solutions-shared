variable "vcd_user" {
  description = "vCloud Director username."
  default = "admin"
}

variable "vcd_password" {
  description = "vCloud Director instance password."
  default = ""
}

variable "vcd_org" {
  description = "vCloud Director organization name/id."
  default = ""
}

variable "vcd_url" {
  description = "vCloud Director url."
  default = "https://daldir01.vmware-solutions.cloud.ibm.com/api"
}

variable "vdc_name" {
  description = "vCloud Director virtual datacenter."
  default = "vmware-tutorial"
}

variable "vdc_edge_gateway_name" {
  description = "vCloud Director virtual datacenter edge gateway name."
  default = ""
}

variable "allow_ssh" {
  description = "Set to false to not configure SSH into the VM."
  default = true
}
