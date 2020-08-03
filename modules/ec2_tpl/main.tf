#-# Modules/EC2_tpl/Main.tf #-#

resource "aws_instance" "this" {
    count = length (var.ec2_instances) > 0 ? length(var.ec2_instances) : 0
    ami = lookup(var.ec2_instances[count.index],"ami")
    subnet_id  = lookup(var.subnets_list,lookup(var.ec2_instances[count.index], "subnet_name"), null)
    key_name = lookup(var.ec2_instances[count.index], "key_name", null)   
    vpc_security_group_ids = flatten([
        for sgn in lookup(var.ec2_instances[count.index],"vpc_security_group_names"): [
            lookup(var.security_group_list,sgn)
        ]
    ])
    # Tags for EC2 instances
    tags = merge(
        {
        Name = lookup(var.ec2_instances[count.index],"ec2_tag_name")
        }, var.common_tags, var.additional_tags
    )
    # Tags for all EBS volumes (root & non-root EBS) attached to EC2. To create separate tags for each EBS, create separate ebs volumes and attach to EC2 instances.
    volume_tags = merge (
        {
        Name = lookup(var.ec2_instances[count.index],"volume_tag_name", null)
        }, var.common_tags, var.additional_tags
    )

    # Optional Root EBS volume attributes (Default values from AMI will be used if this is not provided)
    root_block_device {
        volume_type = lookup(var.ec2_instances[count.index].root_block_device, "volume_type", null)
        volume_size = lookup(var.ec2_instances[count.index].root_block_device, "volume_size", null)
        iops = lookup(var.ec2_instances[count.index].root_block_device, "iops", null)
        delete_on_termination = lookup(var.ec2_instances[count.index].root_block_device, "delete_on_termination", null)
        encrypted = lookup(var.ec2_instances[count.index].root_block_device, "encrypted", null)
        kms_key_id = lookup(var.ec2_instances[count.index].root_block_device, "kms_key_id", null)
    }

    # Common optional inputs
    iam_instance_profile = lookup(var.ec2_instances[count.index], "iam_instance_profile", null)
    user_data = var.user_data
    # Optional inputs  (Rarely used)
    instance_type = lookup(var.ec2_instances[count.index],"instance_type")
    associate_public_ip_address = lookup(var.ec2_instances[count.index],"associate_public_ip_address", null)
    source_dest_check = lookup(var.ec2_instances[count.index],"source_dest_check", null)
    tenancy = lookup(var.ec2_instances[count.index],"tenancy", null)
    cpu_core_count = lookup(var.ec2_instances[count.index],"cpu_core_count", null)
    cpu_threads_per_core  = lookup(var.ec2_instances[count.index],"cpu_threads_per_core", null)

    # Added in ignore changes for volume tags so that any new non-root ebs volumes will not have the same tag name as the root ebs volume 
    # Note: For root ebs volume tags will need to be manually changed next time
    lifecycle {
         ignore_changes = [volume_tags]
    }
}