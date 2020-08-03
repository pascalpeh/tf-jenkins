#-#--------- jenkins/root/outputs.tf ---------#-#


output "subnets_list" {
    value = module.subnets.subnets_list
}

output "security_group_list" {
    value = module.security_groups.security_groups_list
}