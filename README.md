# Terraform EC2 Nginx Deployment

---

This project is created as part of the Terraform Infrastructure as Code assignment. The main goal of this task is to provision an AWS EC2 instance using Terraform and configure it as an Nginx web server on Ubuntu.

The EC2 instance is created in the default VPC, and the required networking access is handled using a security group. Once the instance is launched, Terraform passes a user data script to the server. This script installs Nginx and replaces the default Nginx landing page with a custom HTML page.

---

## Project Execution Overview

This project is executed in **4 phases**, starting from Terraform configuration and ending with validation and clean-up of the AWS resources.

### Phases of Deployment

- **Phase 1:** Terraform Configuration
- **Phase 2:** Variable and User Data Setup
- **Phase 3:** Terraform Execution
- **Phase 4:** Verification and Destroy

---

## Environment

### Cloud Platform
- AWS

### AWS Services Used
- EC2
- Security Group
- Default VPC
- Default Subnet

### Operating System
- Ubuntu 20.04 LTS

### Web Server
- Nginx

## Technology Stack
- Terraform
- AWS Provider
- Shell Script
- Git

---

## Project File Structure

The project contains the Terraform configuration files required to create the EC2 instance and install Nginx.

```
Skill-Test-3-Reattempt/
|-- main.tf
|-- providers.tf
|-- variables.tf
|-- outputs.tf
|-- terraform.tfvars
|-- user_data.sh
|-- README.md
|-- .gitignore
```

### File Details

- `providers.tf` - Contains the AWS provider configuration and region setup.
- `main.tf` - Contains the main AWS resources like AMI lookup, default VPC, default subnet, security group, and EC2 instance.
- `variables.tf` - Contains variables used in the Terraform configuration.
- `terraform.tfvars` - Contains sample placeholder values for the variables.
- `outputs.tf` - Prints the public IP address and Nginx URL after provisioning.
- `user_data.sh` - Installs Nginx and creates a custom index page on the EC2 instance.
- `.gitignore` - Ignores Terraform state files, provider folders, images, and other local files.

---

## Resources Created

The below resources are created using Terraform:

1. **Ubuntu 20.04 LTS AMI lookup**

   Terraform uses the AWS AMI data source to fetch the latest Ubuntu 20.04 LTS AMI owned by Canonical.

2. **Default VPC and Subnet**

   This project uses the default VPC and default subnet available in the selected AWS region. No custom VPC, subnet, route table, or internet gateway is created.

3. **Security Group**

   A security group is created for the Nginx server with the below inbound rules:

   - HTTP on port `80`
   - SSH on port `22`

   Outbound traffic is allowed so that the instance can download packages during the Nginx installation.

4. **EC2 Instance**

   Terraform launches an Ubuntu EC2 instance and attaches the security group to it. The instance receives the user data script during launch.

5. **Nginx Web Server**

   Nginx is installed automatically using `user_data.sh`. The default Nginx page is replaced with the below custom message:

   ```
   Welcome to the Terraform-managed Nginx Server on Ubuntu
   ```

---

## Phase 1: Terraform Configuration

### Task-1: Configure AWS Provider

1. The AWS provider is configured in `providers.tf`.
2. The provider uses the region value from the `aws_region` variable.

   ```
   provider "aws" {
       region = var.aws_region
   }
   ```

3. The required AWS provider source is defined as `hashicorp/aws`.

---

## Phase 2: Variable and User Data Setup

### Task-1: Configure Variables

1. The project uses variables for region, instance type, security group name, and public IP association.
2. These values can be updated from `terraform.tfvars`.

   ```
   aws_region          = "<mention your AWS region here>"
   instance_type       = "<mention your desired EC2 instance type here>"
   security_group_name = "<mention your desired security group name here>"
   pub_ip_assoc        = true/false
   ```

> [!NOTE]
> The values in `terraform.tfvars` are kept as placeholders intentionally. Before running Terraform in a real AWS account, replace them with actual values. For this assignment, the instance type can be set as `t2.micro`.

### Task-2: Configure User Data

1. The `user_data.sh` file is passed to the EC2 instance during launch.
2. This script updates the package list, installs Nginx, replaces the default index page, and enables the Nginx service.

   ```
   apt-get update -y
   apt-get install nginx -y
   systemctl start nginx
   systemctl enable nginx
   ```

3. The custom HTML page is written inside `/var/www/html/index.html`.

---

## Phase 3: Terraform Execution

### Task-1: Configure AWS CLI

1. Before running Terraform commands, AWS CLI should be configured on the machine.
2. Terraform uses these AWS credentials to connect to the AWS account and create the required resources.
3. Run the below command to configure AWS CLI.

   ```
   aws configure
   ```

4. Enter the required details when prompted.

   ```
   AWS Access Key ID [None]: <your-access-key-id>
   AWS Secret Access Key [None]: <your-secret-access-key>
   Default region name [None]: <your-aws-region>
   Default output format [None]: json
   ```

   <img width="895" height="161" alt="aws_configure" src="https://github.com/user-attachments/assets/798d2bd9-55dc-4f44-90da-2f9ba421b558" />

5. The region entered here should match the region used in `terraform.tfvars`.
6. Once configured, run the below command to confirm that AWS CLI is able to connect to the account.

   ```
   aws sts get-caller-identity
   ```

> [!NOTE]
> Do not commit AWS access keys or secret keys in the repository. Also avoid uploading screenshots that show the access key, secret key, account details, or any other confidential information.

### Task-2: Initialize Terraform

1. Navigate to the project folder.

   ```
   cd Skill-Test-3-Reattempt
   ```

2. Run the below command to initialize Terraform and download the required provider plugins.

   ```
   terraform init
   ```

   <img width="813" height="415" alt="terraform_init" src="https://github.com/user-attachments/assets/38e69721-9a86-47ce-b070-dfec5c4ef174" />


### Task-3: Validate Terraform Configuration

1. Run the below command to validate the Terraform files.

   ```
   terraform validate
   ```

   <img width="840" height="39" alt="terraform_validate" src="https://github.com/user-attachments/assets/0058ed96-10da-4050-8638-e25e0085d1e4" />

### Task-4: Review the Terraform Plan

1. Run the below command to check which resources will be created.

   ```
   terraform plan
   ```

2. Review the plan output carefully before applying the configuration.

   <img width="999" height="1047" alt="terraform_plan_1" src="https://github.com/user-attachments/assets/05c2cf64-e923-4e25-a03b-1c30b9e5468a" />

   <img width="1063" height="1065" alt="terraform_plan_2" src="https://github.com/user-attachments/assets/9fca9ac0-f4c1-445c-93a9-eba17809eb7b" />

### Task-5: Apply Terraform Configuration

1. Run the below command to create the AWS resources.

   ```
   terraform apply
   ```

2. When Terraform asks for confirmation, type `yes`.

3. After the apply is completed, Terraform prints the public IP and Nginx URL from the output values.

   <img width="1120" height="699" alt="terraform_apply" src="https://github.com/user-attachments/assets/00b275cf-8521-44f3-ac1b-281b1813be53" />

---

## Phase 4: Verification and Destroy

### Task-1: Verify the Nginx Web Page

1. Copy the public IP address from the Terraform output.
2. Open the below URL in the browser.

   ```
   http://<public-ip>
   ```

3. The browser should show the custom Nginx page with the message configured in `user_data.sh`.


   <img width="1919" height="1143" alt="validation" src="https://github.com/user-attachments/assets/52f5b26e-93dc-44d1-96e3-2d1b7c783a7c" />

> [!NOTE]
> The instance should have a public IP associated with it to access the Nginx page from the browser.

### Task-2: Destroy the Resources

1. After verification is completed, run the below command to delete all the resources created by this Terraform project.

   ```
   terraform destroy
   ```

2. When Terraform asks for confirmation, type `yes`.
3. This removes the EC2 instance and the security group created for the project.
