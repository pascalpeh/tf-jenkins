#-#------- Modules/Route Tables/Outputs.tf------#-#

# Output all route table ids
output "route_tables_id" {
  description = "Output all route table ids"
  value = aws_route_table.this.*.id
}

# Output a list of route tables names and their ids
output "route_tables_list" {
    description = "Output a list of route table names and their id"
    value = {
        for rt in aws_route_table.this :
        lookup(rt.tags, "Name") => rt.id
    }
}