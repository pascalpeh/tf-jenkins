#-#--------Modules/VPC/Outputs.tf--------#-#

# Output the vpc id
output "vpc_id" {
  description = "Output the vpc id"
  value = aws_vpc.this.id
}