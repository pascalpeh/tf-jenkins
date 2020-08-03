#-#--------- jenkins/root/terraform.auto.tfvars ---------#-#

# Region for AWS
region = "ap-southeast-1"

# VPC CIDR details
vpc_cidr = "192.168.1.0/24"
vpc_name = "cw-sb-vpc-01"
common_tags  = {
    Owner = "Chee Wei"
    Environment = "Jenkins"
    Description = "Created using Terraform"
}

# Subnet details
subnets = [
    # Public web subnets
    {
        cidr_block = "192.168.1.0/28",
        availability_zone = "ap-southeast-1a"
        subnet_name = "cw-sb-sub-a-pub-01"
        map_public_ip_on_launch = "true"
    },
    {
        cidr_block = "192.168.1.16/28",
        availability_zone = "ap-southeast-1b"
        subnet_name = "cw-sb-sub-b-pub-01"
        map_public_ip_on_launch = "true"
    }

]

# Internet gateway details
igw_name = "cw-sb-igw-01"

# Route Table details
route_tables = [
    {
        Name = "cw-sb-rt-pub-01"
        Purpose = "Route Table for Public subnets"
    }
]

# IGW Routes details
pub_routes = [
    {
        name = "cw-sb-rt-pub-01"
        destination_cidr = "0.0.0.0/0"
    }
]

# Route table associations
route_table_associations = [
    # Route table associations for public subnets
    {
        subnet_name = "cw-sb-sub-a-pub-01"
        route_table_name = "cw-sb-rt-pub-01"       
    },
    {
        subnet_name = "cw-sb-sub-b-pub-01"
        route_table_name = "cw-sb-rt-pub-01"       
    }
]

# NACLs details (Empty NACLs for now)
nacls = [
# NACLs for public subnets
{
	nacl_name = "cw-sb-nacl-pub-01" 
	subnet_names = ["cw-sb-sub-a-pub-01","cw-sb-sub-b-pub-01"]                  # Subnets that needs to be applied with NACL rule
    ingress = [
            {
                protocol   = "-1"
                rule_no    = 100
                action     = "allow"
                cidr_block = "0.0.0.0/0"
                from_port  = "0"
                to_port    = "0"
            }
        ]

        egress = [
            {
                protocol   = "-1"
                rule_no    = 100
                action     = "allow"
                cidr_block = "0.0.0.0/0"
                from_port  = "0"
                to_port    = "0"
            }
        ]
}
]


# Security Group variables
security_groups = [
    {
    # Security Group for Bastion hosts
      name = "cw-sb-sg-bastion-001"
      sg_description = "Security Group for Bastion login"
      ingress = [
        {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["180.129.65.168/32"]
        rule_description = "SSH rule"
        },
        # Allow ICMP ping (For troubleshooting purposes)
        {
        from_port = "-1"
        to_port = "-1"
        protocol = "icmp"
        cidr_blocks = ["180.129.65.168/32"]
        rule_description = "Allow ICMP Ping"
        }
      ]
    },
    # Security Group for Web access
    {
      name = "cw-sb-sg-web-001"
      sg_description = "Security Group for Web Access"
      ingress = [
        {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["180.129.65.168/32"]
        rule_description = "Jenkins Server Inbound Rule for administration"
        },
        {
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        rule_description = "Docker Production Container Inbound Rule"
        },
        {
        from_port = 3001
        to_port = 3001
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        rule_description = "Docker Staging Container Inbound Rule"
        },
        {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["192.30.252.0/22"]
        rule_description = "Jenkins Server Inbound Rule for Github webhooks"
        },
        {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["185.199.108.0/22"]
        rule_description = "Jenkins Server Inbound Rule for Github webhooks"
        },
        {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["140.82.112.0/20"]
        rule_description = "Jenkins Server Inbound Rule for Github webhooks"
        },
      ]
    }
  ]

# EC2 variables for Jenkins Server
  jenkins_ec2 = [ 
    {
        ec2_tag_name = "cw-sb-vm-a-r7-js-01"    # EC2 Tag Name
        os_hostname = "jenkins01"               # OS Hostname
        ami = "ami-02079c0159aade6b4"			# Create from RHEL-7.7_HVM-20190923-x86_64-0-Hourly2-GP2
        instance_type = "t2.micro"
        vpc_security_group_names = ["cw-sb-sg-bastion-001","cw-sb-sg-web-001"]
        subnet_name = "cw-sb-sub-a-pub-01"
        key_name = "my-keypair"
        volume_tag_name = "cw-sb-ebs-a-js01-os"
        user_data_file_path = "../../scripts/linux/install_jenkins_nodejs_docker-ce.sh"
        root_block_device = {
        }
    }
]