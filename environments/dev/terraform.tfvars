vpc_cidr            = "10.0.0.0/16"
subnet_cidr         = "10.0.1.0/24"
availability_zone   = "us-east-1a"
ami_id              = "ami-0b6d9d3d33ba97d99"  # Ubuntu 22.04 LTS in us-east-1
instance_type       = "t3.micro"
allowed_cidr_blocks = ["0.0.0.0/0"]  # Change to your specific IP or CIDR range for better security

# SSH key pair: set existing_key_name to reuse a key pair already in AWS (us-east-1),
# or leave it null to create a new key pair from the local public key below.
existing_key_name = null
public_key_path   = "~/.ssh/id_ed25519.pub"

# Number of EC2 instances to create
instance_count = 1
github_environment = "dev"