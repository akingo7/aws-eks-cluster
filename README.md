# EKS Cluster Deployment with Terraform

This Terraform configuration sets up an EKS cluster on AWS with the following components:

## Infrastructure

* **VPC:** A dedicated VPC is created with public and private subnets across three availability zones.
* **EKS Cluster:** An EKS cluster is provisioned with specified version and configuration.
* **Node Groups:** Managed node groups are configured with desired instance types and scaling parameters.
* **Security Groups:** Security groups are defined to control network traffic to and from the cluster.

## Features

* **ALB Ingress Controller:** Deploys the AWS Load Balancer Controller to manage ingress traffic to the cluster.
* **Cluster Addons:** Enables essential cluster addons like CoreDNS, kube-proxy, and VPC CNI.
* **IAM Roles and Policies:** Creates necessary IAM roles and policies for cluster components.
* **Cluster Access:** Configures cluster access for administrators and service accounts.

## Configuration

The configuration is defined in the following files:

* **`variables.tf`:** Defines variables for customizing the deployment, such as region, VPC CIDR, and node group settings.
* **`backend.tf`:** Configures the Terraform backend to store state locally.
* **`providers.tf`:** Specifies the required providers, including AWS, Kubernetes, and Helm.
* **`vpc.tf`:** Defines the VPC module, creating the network infrastructure for the cluster.
* **`eks.tf`:** Configures the EKS cluster module, including node groups, addons, and access settings.
* **`security-groups.tf`:** Defines security groups for controlling network access to cluster resources.
* **`main.tf`:** Contains the main configuration for deploying the ALB Ingress Controller and other resources.
* **`outputs.tf`:** Defines outputs for accessing cluster information, such as the cluster name and endpoint.

## Usage

1. **Prerequisites:**
    * Install Terraform and configure AWS credentials.
    * Ensure you have the necessary permissions to create and manage AWS resources.
2. **Configuration:**
    * Review and modify the variables in `variables.tf` to match your desired settings.
3. **Deployment:**
    * Initialize Terraform: `terraform init`
    * Apply the configuration: `terraform apply`
4. **Verification:**
    * Verify the cluster is created and running: `kubectl get nodes`
    * Access the cluster using kubectl: `aws eks update-kubeconfig --name <cluster_name> --region <region>`

## Cleanup

To destroy the infrastructure created by this configuration, run:

```bash
terraform destroy
```
