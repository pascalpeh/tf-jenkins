# Terraform IaC for Jenkins Server on AWS

## Overview
This repository creates an EC2 instance (OS RedHat 7.7) running on AWS along with the following packages
* Jenkins server version 2.250
* Docker Engine community version 19.03.12
* NodeJS version 12.18.3
* Git version 1.8.3.1

## Requirements
* AWS Account with access/secret keys and permissions to create resources such as vpc, subnets, security groups, EC2 instances, etc
* Terraform software binary (download from https://www.terraform.io/downloads.html)

## Terraform version
Tested using Terraform version v0.12.24

## How to use/run
1. Add AWS access/secret keys in AWS CLI on your machine
2. Run "terraform init" to download all required aws plugins and initialize modules
3. Run "terraform plan" to show a plan of AWS resources to be created 
4. Run "terraform apply" to create the AWS resources 

