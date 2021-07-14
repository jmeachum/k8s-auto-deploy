#!/bin/bash
# TODO: Exit if aws configure fails.
# Configure CLI
aws configure

#TODO: Prompt for S3 Bucket name.
# Bucket var for terraform
read -e -p "Enter the name of the S3 bucket to use as backend for Terraform: " S3_BUCKET

#TODO: Error handling if bucket name is already used, prompt for new name and try again. 
# Create s3 bucket for terraform
until aws s3api create-bucket --bucket ${S3_BUCKET}
do
    read -e -p "Create bucket failed. Please provide a new name: " S3_BUCKET
done
# Generate a unique identified for this build. UUID is the easiest
UUID=$(uuid -v4)

# Pass the unique identifier to packer as a user variable
packer build -var build_uuid=${UUID} -on-error=ask ./builds/k8s-base.pkr.hcl

# TODO: Sleep routine may be needed here. Need to confirm AMI_ID was retrieved before moving on. 
# On first run terraform errored on ami_id var not being set, however there is a var block for it set to default, 
# also confirmed expected value was in plan so not sure if this was a one-off.
# Query for AMI_ID using tag
AMI_ID=$(aws ec2 describe-images --filters Name=tag:build-uuid,Values=${UUID} --output text --query 'Images[0].ImageId')

# Add bucket name to backend.tf
sed -i s/S3_BUCKET/${S3_BUCKET}/g ./terraform_files/backend.tf

# Generate ssh key for ec2 instances. 
#TODO: Use Hashicorp Vault to store key, or do this as a setup step before script is run and pull.
ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N ""

# TODO: Exit if backend setup fails.
# Init to setup backend
terraform -chdir=terraform_files init

# Terraform plan
terraform -chdir=terraform_files plan -var="ami_id=${AMI_ID}" -out=tfplan

# Terraform apply
terraform -chdir=terraform_files apply tfplan

# TODO: Remove this block after testing. Sets back to default.
# Revert back for testing name to backend.tf
sed -i s/${S3_BUCKET}/S3_BUCKET/g ./terraform_files/backend.tf

# Build cluster using kubespray
# ansible-playbook cluster.yml

# Build app
# Deploy app