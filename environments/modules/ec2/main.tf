resource "aws_key_pair" "test_key" {
    count = var.existing_key_name == null ? 1 : 0
    key_name = "test-ec2-key"
    public_key = file(pathexpand(var.public_key_path))
}

locals {
    key_name = var.existing_key_name != null ? var.existing_key_name : aws_key_pair.test_key[0].key_name
}

resource "aws_iam_role" "ec2_role" {
    name = "test-ec2-ecr-pull-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect    = "Allow"
            Principal = { Service = "ec2.amazonaws.com" }
            Action    = "sts:AssumeRole"
        }]
    })
}

resource "aws_iam_role_policy_attachment" "ecr_read" {
    role       = aws_iam_role.ec2_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_profile" {
    name = "test-ec2-instance-profile"
    role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "test1-ec2" {
    count = var.instance_count
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    associate_public_ip_address = true
    key_name = local.key_name
    vpc_security_group_ids = [aws_security_group.test_group.id]
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

    # Installs Docker and AWS CLI v2 on first boot
    user_data = <<-EOF
        #!/bin/bash
        set -euo pipefail
        apt-get update
        apt-get install -y docker.io unzip curl
        systemctl enable --now docker
        usermod -aG docker ubuntu
        curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
        unzip -q /tmp/awscliv2.zip -d /tmp
        /tmp/aws/install
    EOF

    tags = {
        Name = "test-ec2-${count.index + 1}"
    }
}

moved {
    from = aws_instance.test1-ec2
    to   = aws_instance.test1-ec2[0]
}

# Fixed public IP per instance, so the address survives stop/start
resource "aws_eip" "test1-eip" {
    count    = var.instance_count
    domain   = "vpc"
    instance = aws_instance.test1-ec2[count.index].id

    tags = {
        Name = "test-ec2-eip-${count.index + 1}"
    }
}

resource "aws_security_group" "test_group" {
    name = "test-security-group"
    description = "Security group for test EC2 instance"
    vpc_id = var.vpc_id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = var.allowed_cidr_blocks

    }

    ingress {
        description = "HTTP for the app"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = var.allowed_cidr_blocks
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}