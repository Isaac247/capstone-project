# Capstone-project
## Overview  
Deploying a microservices-based architecture application on Kubernetes using a clear IaaC (Infrastructure as Code) deployment to be able to deploy the services in a fast manner.  
## Getting started 

### Step 1: Infrastructure Provisioning
Using Terraform, necessary resources such as VPCs, subnets, S3 buckets, security groups and an EKS cluster will be provisioned using terraform 
1. Create a new directory and clone this repo in it 
  ~~~  
  git clone https://github.com/Isaac247/capstone-project.git
  ~~~
2. Move to the terraform folder and initialize terraform
  ~~~
  cd terraform/
  terraform init
  ~~~
3. Run the terraform validate and execution plan to check for errors as well as creating an execution plan
  ~~~
  terraform validate  
  terraform plan
  ~~~
4. Run the terraform apply command
  ~~~
  terraform apply --auto-approve
  ~~~   


![img1](images/cluster-creation-cli.PNG)  
creation process of the EKS cluster  

![img2](/home/mamman/project/images/cluster-creation-aws.PNG)
EKS cluster created successfullly
