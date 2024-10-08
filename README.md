# Socks shop Microservice-based Application Deployment on Kubernetes Using IaC(Terraform)
![img9](images/Blank%20diagram%20(1).png)
## Overview  
Deploying a microservice-based architecture application on Kubernetes using a clear IaC (Infrastructure as Code) deployment to be able to deploy the services in a fast manner.  
## Requirements
* AWS Account configured on an AWS CLI
* Helm Installed
* Terraform installed and configured to an AWS account
* Domain name
* Kubernetes installed
## Getting started 
### Step 1: CI/CD pipeline
For the continous integration and deployment aspect, 2 pipelines were created to handle terraform infrastructure provisioning and the other to handle the kubernetes aspect so as to stop the reoccurence of provisioning aws resources after every action 
### Step 2: Infrastructure Provisioning
Using Terraform, necessary resources such as VPCs, subnets, S3 buckets, security groups and an EKS cluster will be provisioned using terraform 
1. Create a new directory and clone this repo 
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
Creation process of the EKS cluster  

![img2](images/cluster-creation-aws.PNG)
EKS cluster created successfullly  

### Step 3: Deploying manifest file to the EKS cluster created  
1. Move to kubernetes directory 
 ```
 cd kubernetes/
 ```
2. Configure Kubectl to connect to the Eks cluster 
 ```
 aws eks update-kubeconfig -name=socks-shop-cluster --region=us-east-1
 ```  
 ![img3](images/configure_eks_to_kubectl.PNG)
3. Apply deployment manifest file to the EKS cluster just created
 ```
 kubectl apply -f socks_shop_deployment.yaml
 ```  
4. After deployment is successful, create a new name space called "sock-shop" because the manifest was deployed there   

5. Run this commands to get the pods and services runing on the Eks cluster
 ```
 kubectl get pods
 kubectl get svc
 ```
 ![img4](images/change_ns-and%20-check_pods_and-svc.PNG)
  
### Step 4: Monitoring and Logging using Ingress Nginix controller
For the monitoring and logging aspect, helm was used to install prometheus and grafana chart respectively. 
1. Install nginx chart using helm
 ```
 helm repo add nginx-stable https://helm.nginx.com/stable
 helm repo update
 helm install nginx-stable/nginx-ingress
 ```
 ![img8](images/helm_ingress_install.PNG)
 
2. Create an **A record** on Route53 to map the ingress external IP address to a domain name. Also, create a **CNAME** rcord that will serve the other services (prometheus and grafana)  
3. Create a rule to serve the frontend of the socks shop application exposing the service name and port number in the ingress manifest file 
 ```
  - host: socks.isaacmamman.me
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: front-end
                port:
                  number: 80
 ```
 ![img5](images/frontend.PNG)
 Sock shop frontend
4. Install prometheus chart using helm
 ```
 helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
 helm repo update
 helm install prometheus prometheus-community/prometheus
 ```
5. Create a rule to serve prometheus service exposing the service name and port number in the ingress manifest file
 ```
 - host: grafana.isaacmamman.me
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: prometheus-grafana
                port:
                  number: 80
 ```
 ![img6](images/prometheusui.PNG)
6. Install grafana chart using helm
 ```
helm repo add grafana https://grafana.github.io/helm-charts 
helm repo update
helm install grafana grafana/grafana
 ```
7. Create a rule to serve prometheus service exposing the service name and port number in the ingress manifest file
 ```
 - host: prometheus.isaacmamman.me
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: prometheus-kube-prometheus-prometheus
                port:
                  number: 9090
 ```
![img7](images/grafana.PNG)
Monitoring