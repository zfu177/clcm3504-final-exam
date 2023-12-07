# CLCM3504 Final Exam
GitHub Repository: https://github.com/zfu177/clcm3504-final-exam
## Author: Zhongyi Fu
This frontend application is solely developed by me for the group project CLCM3504, original GitHub repo: https://github.com/zfu177/techco-frontend-3504-g1

## How to Set Up This Project
### 1. Add SSH Private Key to the Repository Secrets
Have a SSH key pair ready.

From GitHub Settings --> Security --> Secrets and Variables --> Actions, Add a new Repository secret
* Name: SSH_PRIVATE_KEY
* Value: The content of your SSH private key

### 2. Add your SSH Public Key to the "deploy/userdata.sh"
Replace the value of the SSH Public Key in the file "deploy/userdata.sh" line 4

### 3. Provision EC2 instance
There are two options to provision the EC2 instance.
#### Option 1: Use Terraform file "deploy/ec2.tf" 
Prerequisite: Have your AWS Credentials configured.
```bash
cd deploy
terraform init
terraform plan
terraform apply
```
This will output the Public DNS of the EC2 instance, for example:
```bash
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

aws_instance_id = "i-08f27854285044769"
aws_instance_public_dns = "ec2-54-92-214-119.compute-1.amazonaws.com"
```

#### Option 2: Manually Launch a EC2 instance
Login to AWS Management Console, navigate to the EC2 Console.

Firstly, create a security group which allows inbound traffic SSH/22 and HTTP/80 from anywhere, allow all outbound traffic.

Secondly, launch a EC2 instance with following settings:
* AMI: Amazon Linux 2023
* Instance Type: t2.micro
* Key Pair: Use Any of your Key Pair
* VPC: Your choice
* Subnet: Any Public Subnet
* Security Group: Select the one created before
* Advanced Details (Important!!!):
  * User data: Copy and paste the content from file "deploy/userdata.sh", this is used to setup the execution environment, install docker and docker compose, setup SSH public Key used for CICD.
  * IAM instance profile: Optionally select a profile which has SSM and CloudWatch Permission for future use with AWS SSM agent and CloudWatch Agent for advanced monitoring and control

For all the other settings, keep default.

### 4. Update Pipeline Env
Copy the terraform outputed "aws_instance_public_dns" value or manually copy the public DNS name of the launched EC2 instance from the management console, replace the env "host_name" value from the ".github/workflows/deploy.yml" (line 9)

### 5. Push Code
Everything is set up, now just push the code, wait for the GitHub Actions pipeline running, when it's done, test the website accessibility through the URL (public DNS name of the EC2 instance)

## CICD Workflow
".github/workflows/deploy.yml" file defines the CICD workflow for the deployment of this application to EC2 instance.

### Trigger on Push to "main" Branch
The pipeline is triggered whenever a push is made to the "main" branch.


### Global Environment Variables
Two global environment variables "host_name" and "user_name" are defined, which should be the values of the EC2 instance public DNS name and the login username.

### Jobs
One "deploy" job is defined, which runs on "ubuntu" container, has an environment variable "image_tag" defined, which retrieves the GitHub commit SHA and use it as a tag for the docker image.

Five steps are defined in the "deploy" job.
1. Checkout Code: Pull the code to the container running environment
2. Build the Docker image: Build docker image using Dockerfile and tag it with "image_tag" environment variable
3. Save docker image as file: Save the docker image as a tar file to "deploy" directory
4. Copy files to ec2: Use GitHub Action "appleboy/scp-action@master" to copy three files under the "deploy" direcotry to the remote EC2 instance "deploy" folder
5. Start Container: 
   1. Load the copied "*.tar" file as a docker image using the docker command "docker load -i"
   2. Use "sed" command to replace the String "IMAGE_NAME" in the "compose.yaml" file to the current Image_tag
   3. Check if application systemd service file exist, if not exist, copy the file to "/etc/systemd/system/", enable and start the application as systemd service; If already exist, restart the service
   4. Delete the copied image file "*.tar"


This application is managed by "systemd" and docker compose, which ensures that the application is automatically started when the OS reboot. In addition, the docker compose file defines health check using "curl" command to periodically check the health of the container and automatically restart. However, if the EC2 instance is restarted, the public DNS name will change, please keep the "host_name" variable up-to-date to avoid pipeline failure. Alternatively, assign and replace the value of "host_name" to the EIP of the EC2 instance.

## Challenges
No Challenges, this is a simple setup.

## Test & Screenshot
![Index](https://github.com/zfu177/clcm3504-final-exam/blob/main/screenshot.png?raw=true)