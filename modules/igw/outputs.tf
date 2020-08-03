#-#----------Modules/IGW/Outputs.tf-----------#-#

output "igw_id" {
  value = aws_internet_gateway.this.id
}
