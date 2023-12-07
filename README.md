# CLCM3504 Final Exam
## Author: Zhongyi Fu

## How to Set Up This Project
### 1. Add SSH Private Key to the Repository Secrets
Have a SSH key pair ready.

From GitHub Settings --> Security --> Secrets and Variables --> Actions, Add Repository secrets
* Name: SSH_PRIVATE_KEY
* Value: The content of your SSH private key

### 2. Provision EC2 instance
There are two options to provision the EC2 instance.
#### Option 1: Use Terraform file "deploy/ec2.tf" 
Prerequisite: Have your AWS Credentials configured.
```bash
cd deploy
terraform init
terraform plan
terraform apply
```

#### Option 2: Manually Launch a EC2 instance
Login to your AWS Management Console, navigate to the EC2 Console.

Firstly, create a security group which allows inbound traffic SSH/22 and HTTP/80 from anywhere, allow all outbound traffic.

Secondly, launch a EC2 instance with following settings:
* AMI: Amazon Linux 2023
* Instance Type: t2.micro
* Key Pair: Use Any of your Key Pair
* VPC: Your choice
* Subnet: Any Public Subnet
* Security Group: Select the one created before
* Advanced Details (Important!!!):
  * User data: Copy and paste the content from file "deploy/userdata.sh", this is used to setup the execution environment, install docker and docker compose, setup SSH public Key used for CICD. Please note that the SSH public key must match the Private key added in "Add SSH Private Key to the Repository Secrets" step
  * IAM instance profile: Optionally select a profile which has SSM and CloudWatch Permission for future use with AWS SSM agent and CloudWatch Agent

For all the other settings, keep default.

### 3. Update Pipelie Env
Copy the terraform outputed "aws_instance_public_dns" value or manually copy the public dns name of the launched EC2 instance, replace the env "host_name" value from the ".github/workflows/deploy.yml" (line 9)

### 4. Push Code
Everything is set up, now just push the code, wait for the GitHub Actions pipeline running, when it's done, test the website accessibility through the URL (public DNS name of the EC2 instance)