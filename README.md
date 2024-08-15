# Socks shop Microservice-based Application Deployment on Kubernetes Using IaC(Terraform)
## Overview  
Deploying a microservices-based architecture application on Kubernetes using a clear IaC (Infrastructure as Code) deployment to be able to deploy the services in a fast manner.  
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

![img2](images/cluster-creation-aws.PNG)
EKS cluster created successfullly  

### Step 2: Deploying manifest file to the EKS cluster created  
1. Move to kubernetes directory 
 ```
 cd kubernetes/
 ```
2. Configure Kubectl to connect to the Eks cluster 
 ```
 aws eks update-kubeconfig -name=socks-shop-cluster --region=us-east-2
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
  
### Step 3: Monitoring and Logging using Ingress Nginix controller
For the monitoring and logging aspect, helm was used to install prometheus and grafana chart respectively
1. Install nginix chart using helm
 ```
 helm repo add nginx-stable https://helm.nginx.com/stable
 helm repo update
 helm install nginx-stable/nginx-ingress
 ```
 ![img8](images/helm_ingress_install.PNG)
2. Create a rule to serve the frontend of the socks shop application assigning the service name and port number 
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
3. Install prometheus chart using helm
 ```
 helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
 helm repo update
 helm install prometheus prometheus-community/prometheus
 ```
4. Create a rule to serve prometheus service assigning the service name and port number
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
5. Install grafana chart using helm
 ```
helm repo add grafana https://grafana.github.io/helm-charts 
helm repo update
helm install grafana grafana/grafana
 ```
6. Create a rule to serve prometheus service assigning the service name and port number
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
