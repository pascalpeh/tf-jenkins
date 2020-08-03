#-#--------Modules/subnet/Outputs.tf--------#-#

# Output all the subnet ids
output "subnets_id" {
  description = "Output all the subnet ids"
  value = aws_subnet.this.*.id
}

# Output a list of subnet names and their id
output "subnets_list" {
  description = "Output a list of subnet names and their id"
  value = {
    for subnet in aws_subnet.this :
    lookup(subnet.tags, "Name") => subnet.id
  }
}

# Output all the subnets attribute
output "subnets" {
  description = "Output all the subnets attribute"
  value = aws_subnet.this.*
}
