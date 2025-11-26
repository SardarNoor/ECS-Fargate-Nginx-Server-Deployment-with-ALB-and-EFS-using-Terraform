
# **ECS Fargate Nginx Server Deployment with ALB and EFS using Terraform**

This project demonstrates the complete deployment of a highly available and scalable Nginx server on **Amazon ECS Fargate**, fronted by an **Application Load Balancer (ALB)** and backed by **Amazon EFS** for persistent storage.
All infrastructure is provisioned using **Terraform**, following a modular structure and AWS best practices.

---

*
## Architecture Diagram

![Architecture Diagram](./ECS%20Fargate(ALB+EFS)%20(1).png)

The deployment consists of:

* A custom **VPC** spanning multiple Availability Zones
* **Public and private subnets** for proper network separation
* **Internet Gateway** and **NAT Gateway** for controlled internet access
* **Application Load Balancer** (public) to distribute traffic
* **ECS Fargate Service** running a custom Nginx Docker image stored in **ECR**
* **Amazon EFS** for persistent shared storage
* **IAM roles & policies** for ECS, ECR, and EFS access
* **Terraform remote backend** using S3 for state management

**High-Level Flow:**
Clients → ALB → ECS Tasks → EFS (persistent content)

---

## **Features**

* Fully automated, reproducible deployment using Terraform
* Modularized Terraform code structure
* Highly available VPC with multi-AZ deployment
* Custom Docker image with Nginx + startup script
* EFS mounted inside ECS tasks for persistent content
* Scalable Fargate service behind an ALB
* CloudWatch logging for ECS tasks

---

## **Repository Structure**

```
├── html/                     # Custom HTML content
├── modules/                  # Terraform modules (VPC, ECS, ALB, EFS, IAM, etc.)
├── Dockerfile                # Custom Nginx image definition
├── start.sh                  # Startup script (EFS sync + Nginx start)
├── backend.tf                # Terraform remote backend config (S3)
├── provider.tf               # AWS provider config
├── main.tf                   # Core resource definitions
├── variables.tf              # Input variables
├── outputs.tf                # Terraform outputs
└── ECS Fargate(ALB+EFS).pdf  # Detailed documentation (manual/guide)
```

---

## **Prerequisites**

Before deploying, ensure that you have:

* An AWS account
* AWS CLI configured locally
* Terraform installed (v1.x recommended)
* Permissions to create VPC, ECS, ECR, ALB, EFS, IAM roles, etc.

---

## **Deployment Instructions**

### **1. Initialize Terraform**

```
terraform init
```

### **2. Validate Configuration**

```
terraform validate
```

### **3. Review the Deployment Plan**

```
terraform plan
```

### **4. Deploy the Infrastructure**

```
terraform apply -auto-approve
```

### **5. Retrieve the ALB DNS**

After deployment completes, Terraform outputs the ALB DNS name.
Open it in a browser to verify the application.

---

## **Custom Docker Image**

The Nginx image includes:

* Custom HTML page located in `html/index.html`
* A startup script `start.sh` which:

  * Waits for EFS to mount
  * Copies static content to the EFS directory
  * Runs Nginx in the foreground

The image is built locally and pushed to **Amazon ECR**, where ECS Fargate pulls it during deployment.

---

## **Persistent Storage via EFS**

* Every ECS task mounts the same EFS directory.
* Static assets remain persistent even if tasks restart or scale in/out.
* Transit encryption and IAM access points are used for secure access.

---

## **Scaling and Availability**

* The ALB operates across two public subnets for multi-AZ availability.
* ECS tasks run across multiple subnets to avoid single-AZ failure.
* The service can be scaled by adjusting the `desired_count` in Terraform.

---

## **Cleaning Up**

To destroy the entire infrastructure and avoid AWS charges:

```
terraform destroy
```

---

## **Notes**

* Ensure your S3 backend bucket for Terraform state exists before running `terraform init`.
* ECR authentication must be done through the AWS CLI before pushing images.
* If modifying the VPC CIDR or subnet CIDRs, update module variables accordingly.

---

