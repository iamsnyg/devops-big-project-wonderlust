variable "aws_region" {
    description = "The AWS region to deploy resources in"
    type        = string
    default     = "ap-south-1"
}

variable "instance_type" {
    description = "The type of EC2 instance to create"
    type        = string
    default     = "t2.large"
}

variable "ami_id" {
    description = "Ubuntu AMI ID for the EC2 instance"
    type        = string
    default     = "ami-01a00762f46d584a1"
}

