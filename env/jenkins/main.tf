#-#--------- jenkins/root/main.tf ---------#-#

# Use AWS Provider
provider "aws" {
  region = var.region
}

# Create VPC
module "vpc" {
  source      = "../../modules/vpc"
  vpc_cidr    = var.vpc_cidr
  vpc_name    = var.vpc_name
  common_tags = var.common_tags
}

# Create subnets
module "subnets" {
  source      = "../../modules/subnet"
  vpc_id      = module.vpc.vpc_id
  subnets     = var.subnets
  common_tags = var.common_tags
}

# Create IGW
module "igw" {
  source      = "../../modules/igw"
  vpc_id      = module.vpc.vpc_id
  igw_name    = var.igw_name
  common_tags = var.common_tags
}

# Create Route Tables
module "route_tables" {
  source       = "../../modules/route_table"
  vpc_id       = module.vpc.vpc_id
  route_tables = var.route_tables
  common_tags  = var.common_tags
}

# Create routes to connect to IGW
module "route_igw" {
  source            = "../../modules/route_igw"
  routes            = var.pub_routes
  route_tables_list = module.route_tables.route_tables_list
  gateway_id        = module.igw.igw_id
}

# Associate public route table to public subnet
module "route_association" {
  source                   = "../../modules/route_association"
  route_table_associations = var.route_table_associations
  subnets_list             = module.subnets.subnets_list
  route_tables_list        = module.route_tables.route_tables_list
}

# Create NACLs (Allow any to any rules first)
module "nacls" {
  source       = "../../modules/nacl"
  vpc_id       = module.vpc.vpc_id
  nacls        = var.nacls
  subnets_list = module.subnets.subnets_list
  common_tags  = var.common_tags
}

# Create security groups for EC2 instances
module "security_groups" {
  source          = "../../modules/security_group"
  security_groups = var.security_groups
  vpc_id          = module.vpc.vpc_id
}

## Create user template file for Jenkins server
data "template_file" "userdata" {
  template = file("../../scripts/linux/install_jenkins_nodejs_docker-ce.tpl")
  vars = {
    hostname = var.jenkins_ec2[0].os_hostname
  }
}


# Create EC2 instances for jenkins server in public subnet
module "jenkins_ec2" {
  source              = "../../modules/ec2_tpl"
  ec2_instances       = var.jenkins_ec2
  subnets_list        = module.subnets.subnets_list
  security_group_list = module.security_groups.security_groups_list
  user_data           = data.template_file.userdata.rendered
  common_tags         = var.common_tags
}