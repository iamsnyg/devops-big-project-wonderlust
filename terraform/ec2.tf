resource "aws_key_pair" "my_key_pair" {
    key_name   = "my_key_pair"
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_default_vpc" "default" {
    tags = {
        Name = "Default VPC"
    }
}

resource "aws_security_group" "default_sg" {
    name        = "default"
    description = "Default security group"
    vpc_id      = aws_default_vpc.default.id

    ingress {
        description = "Allow SSH access"
        from_port   = 22 // SSH port
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow HTTP access"
        from_port   = 80 // HTTP port
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow HTTPS access"
        from_port   = 443 // HTTPS port
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "default_sg"
    }
}

resource "aws_instance" "candy_machine" {
    ami           = var.ami_id
    instance_type = var.instance_type
    key_name      = aws_key_pair.my_key_pair.key_name
    security_groups = [aws_security_group.default_sg.name]

    root_block_device {
        volume_size = 30 // Size in GB
        volume_type = "gp3"
    }

    tags = {
        Name = "Candy Machine"
    }
  
}

