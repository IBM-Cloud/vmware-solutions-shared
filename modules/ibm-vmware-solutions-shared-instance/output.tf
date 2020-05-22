# output "provider_vdc" {
#   value = data.vcd_org_vdc.tutorials_od.name
# }

output "edge_gateway_name" {
  value = data.vcd_edgegateway.edge.name
}

output "default_gateway_network" {
  value = data.vcd_edgegateway.edge.default_gateway_network
}

output "external_network_name" {
  value = tolist(data.vcd_edgegateway.edge.external_network)[0].name
}

output "default_external_network_ip" {
  value = data.vcd_edgegateway.edge.default_external_network_ip
}

output "external_network_subnet_gateway" {
  value = tolist(tolist(data.vcd_edgegateway.edge.external_network)[0].subnet)[0].gateway
} 

output "suballocate_pool" {
  value = tolist(tolist(tolist(data.vcd_edgegateway.edge.external_network)[0].subnet)[0].suballocate_pool)
} 

# some times this line works and some other times it does not, need to figure out why as the state is always the same
# output "start_address" {
#   value = tolist(tolist(tolist(data.vcd_edgegateway.edge.external_network)[0].subnet)[0].suballocate_pool)[0].start_address
# } 

output "external_network_ips" {
  value = tolist(data.vcd_edgegateway.edge.external_network_ips)
}

output "external_network_ips_1" {
  value = tolist(data.vcd_edgegateway.edge.external_network_ips)[0]
}

output "external_network_ips_2" {
  value = tolist(data.vcd_edgegateway.edge.external_network_ips)[1]
}

output "external_networks" {
  value = tolist(data.vcd_edgegateway.edge.external_networks)
}

output "external_networks_1" {
  value = tolist(data.vcd_edgegateway.edge.external_networks)[0]
}

output "external_networks_2" {
  value = tolist(data.vcd_edgegateway.edge.external_networks)[1]
}
