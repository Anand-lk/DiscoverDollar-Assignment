#Networking Components
variable "cidr_blockvpc" {
    type        = string 
    default     = "10.0.0.0/16" #65536
    description = "provide CIDR for VPC"
}

variable "cidr_blockpubsub1" {
    type        = string
    default     = "10.0.1.0/24" #256 host
    description = "provide CIDR for VPC"
}

variable "cidr_blockpvtsub1" {
    type        = string
    default     = "10.0.3.0/24"
    description = "Provide CIDR for VPC"
}

variable "availability_zone1" {
    type        = string
    default     = "ap-south-1a"
    description = "AWS Zone"
}

variable "instance_type" {
    type        = string 
    default     = "t2.micro"
    description = "provide instance type"
}

variable ami_id {
    type        = string
    default     = "ami-0a606d8395a538502"
    description = "provide AMI"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
    description = "provide instance type"
}