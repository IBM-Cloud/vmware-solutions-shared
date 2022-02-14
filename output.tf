output "virtual_machine_access" {
  value =  nonsensitive(<<VM
  
  ### You can access the vm instance ${vcd_vapp_vm.vm_1.name} using the following SSH command:
      ssh root@${module.ibm_vmware_solutions_shared_instance.default_external_network_ip} 
      
      The initial password is: ${vcd_vapp_vm.vm_1.customization[0].admin_password} 
      
      It is recommended to change the password on first login. 
  VM
  )
}
