#-#------- Modules/Security_group/outputs.tf------#-#

# Output all security groups id
output "security_groups_id" {
  description = "Output all security groups id"
  value = aws_security_group.this.*.id
}

# Output a list of security group names and their id
output "security_groups_list" {
  description = "Output a list of security group names and their id"
  value = {
      for security_group in aws_security_group.this :
        lookup(security_group.tags, "Name") => security_group.id
  }
  
}

