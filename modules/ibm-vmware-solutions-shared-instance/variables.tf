variable "vcd_user" {
  description = "Your vCloud Director username ..."
  default = ""
}

variable "vcd_password" {
  description = "Your vCloud Director instance password  ..."
  default = ""
}

variable "vcd_org" {
  description = "Your vCloud Director organization name/id ..."
  default = ""
}

variable "vcd_vdc" {
  description = "Your vCloud Director virtual datacenter ..."
  default = ""
}

// vcd_vdc_edge
variable "vdc_edge_gateway_name" {
  description = "Your vCloud Director virtual datacenter edge gateway..."
  default = ""
}

variable "vcd_url" {
  description = "Your vCloud Director url ..."
  default = ""
}

variable "vcd_max_retry_timeout" {
  description = "Your vCloud Director retry timeout ..."
  default = 10
}

variable "vcd_allow_unverified_ssl" {
  description = "You ..."
  default = true
}