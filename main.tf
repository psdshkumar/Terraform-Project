provider "aws" {
  region = "ap-south-1" # Replace with your desired AWS region
}

# Security Group to allow SSH traffic
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance resource
resource "aws_instance" "website" {
  ami           = "ami-0dee22c13ea7a9a67" # Replace with your AMI ID
  instance_type = "t2.micro"
  key_name      = "terraform-key"         # Replace with your key pair name
  security_groups = [aws_security_group.allow_ssh.name]

  provisioner "file" {
    source      = "c:/Users/psdsh/Terraform/Terraform-Project/python.py"  # Windows path with forward slashes
    destination = "/home/ubuntu/app.py"  # Path on the EC2 instance where the file will be copied

    connection {
      type        = "ssh"
      user        = "ubuntu"  # Default username for Ubuntu AMIs
      private_key = file("C:/Users/psdsh/Downloads/terraform-key.pem")  # Path to your private key
      host        = self.public_ip
    }
  } provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",
      "sudo apt install python3 -y",  # Fixed missing comma after this line
      "sudo apt install apache2 -y",
      "sudo apt install libapache2-mod-wsgi-py3 -y",
      "sudo apt-get install -y python3-pip",
      "cd /home/ubuntu",
      "sudo pip3 install flask",
      "sudo python3 /home/ubuntu/app.py &"  # Full path to the app.py on the EC2 instance
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"  # Default username for Ubuntu AMIs
      private_key = file("C:/Users/psdsh/Downloads/terraform-key.pem")  # Path to your private key
      host        = self.public_ip
    }
  }

  tags = {
    Name = "TerraformPythonInstance"
  }
}

# Output the public IP of the instance
output "instance_public_ip" {
  value = aws_instance.website.public_ip
}

