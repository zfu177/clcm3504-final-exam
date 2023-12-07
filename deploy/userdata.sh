#!/bin/bash -e

# Add public key to ec2-user
SSH_PUBLIC_KEY='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDiWL1gtQP402kao/kWod6G7VZsCsvokPmLzeAWnFi9HEaden70VMMceTVSiXBsitENRY87SOuUx9CebKLNid0gluGmCVWHesZbtPaQkovhLPHD62JH/wV+A3gIiwAGn/hYD0Epk8hjERGqepVB9OoHwy8bkN2EY7L9OdGcDzrggSMLeK3gaQJWxzdp5qiuzGzv6lSZboMmpBnz4NsXQ79vPiCkjxNuW+T+qfJauUCCnEV7kg4NX8vrtqAVd9lPXfYgVPYIm4N3bPf++arVBlI+sOFDM72ZAHfxHk2rr2ZNIT3bLs4V2uCLUmKSq6rjUq87yu3z62HuUKSsKpTuP4x/UCUNcV4KvFs3nsvKhV4xZtzRE9GLko7mabQeuoYV3DNY889mBn2CzBFeW1dMPlzEPLBz0ni8g5XZ+duRX5oYI+mUVUqsHOuzSnRIlyt/JfDPr9NFK/wlo/W/8tEzEVv+oEbeRizcxw54RYUoNCiGL6XvRKurIImd+NN0Vscx6xNKacRBDand/ixbh74fTYp9Xi0iUKGgs8eF8nOUXU8X1XoyixhftJTZWR0henarVr7NQAjitnZIXUFh8SIwehrT/+a0+gM20t42QYOBwUVXeD+lgX8/CP50+Lbk5d7NJt5A1Ojs+OMgJDG/yeBU5qaV2I5hB0flrtd7yk90oo60mw== eric@hello.local'
echo ${SSH_PUBLIC_KEY} >> /home/ec2-user/.ssh/authorized_keys

yum update && yum upgrade -y

# Install CloudWatch Agent, ssm agent, docker, docker compose
yum install -y git docker amazon-cloudwatch-agent vim amazon-ssm-agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
usermod -aG docker ec2-user
systemctl enable docker
systemctl start docker

mkdir -p /usr/local/lib/docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

echo "Success"
