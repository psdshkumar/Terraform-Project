
 provisioner "remote-exec" {
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
