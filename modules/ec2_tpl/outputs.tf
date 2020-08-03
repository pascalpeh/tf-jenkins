#-# Modules/EC2_tpl/Outputs.tf #-#

# Output a list of EC2 instance tag name with the EC2 instance id
output "ec2_instances_list" {
  description = "Output a list of EC2 instance name and their id"
  value = {
    for ec2 in aws_instance.this :
    lookup(ec2.tags, "Name") => ec2.id
  }
}

# Output all EC2 instances attributes
output "ec2_instances" {
  description = "Output a list of all EC2 instance attributes"
  value = aws_instance.this.*
}
