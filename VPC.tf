#AWS VPC

resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr_blockvpc
    instance_tenancy = "default"

    tags = {
        Name = "MY-VPC"
    }
}

#IGW
resource "aws_internet_gateway" "tigw" {
    vpc_id = aws_vpc.myvpc.id 

    tags = {
        Name = "MY-IGW"
    }
}

#SUBNET
resource "aws_subnet" "pubsub1" {
    vpc_id  = aws_vpc.myvpc.id
    cidr_block = var.cidr_blockpubsub1
    availability_zone = var.availability_zone1

    tags = {
        Name = "MY-PUB-SUB-1"
    }
}

resource "aws_subnet" "pvtsub1" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = var.cidr_blockpvtsub1
    availability_zone = var.availability_zone1
    
    tags = {
        Name = "MY-PVT-SUB-1"
    }
}

#Route Tables
resource "aws_route_table" "pubrt1" {
    vpc_id = aws_vpc.myvpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.tigw.id 
    }
    
    tags = {
        Name = "RTPUB1"
    }
}

resource "aws_route_table" "pvtr1" {
    vpc_id = aws_vpc.myvpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat1.id
    }

    tags = {
        Name = "RTPVT1"
    }
}

#Route Table Association
 resource "aws_route_table_association" "rtpubasc1" {
    subnet_id = aws_subnet.pubsub1.id
    route_table_id = aws_route_table.pubrt1.id
 }

 resource "aws_route_table_association" "rtpvtasc1" {
    subnet_id = aws_subnet.pvtsub1.id
    route_table_id = aws_route_table.pvtrt1.id 
 }

 #EIP
 resource "aws_nat_gateway" "nat1" {
    allocation_id = aws_eip.eip1.id
    subnet_id = aws_subnet.pubsub1.id 

    tags {
        Name = "T-NAT-1"
    }
 }

 #Security Group
 resource "aws_security_group" "pubSG1" {
    name = "allow_tls"
    description = "allow TLS inbound traffic"
    vpc_id = aws_vpc.myvpc.id

    ingress {
        description= "TLS from VPC"
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "MY-PUB-SG1"
    }
 }

resource "aws_security_group" "pvtSG4" {
    name = "allow_tls-1"
    description = "allow TLS inbound traffic"
    vpc_id = aws_vpc.myvpc.id

    ingress {
        description= "TLS from VPC"
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        security_groups = [aws_security_group.pubSG1.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        security_groups = [aws_security_group.pubSG1.id]
        
    }

    tags = {
        Name = "MY-PVT-SG4"
    }
 }

 resource "aws_instance" "web" {
    ami = "ami-0a606d8395a538502"
    instance_type = var.instance_type
    associate_public_ip_address = true 
    subnet_id = aws_subnet.subpub.id
    vpc_security_group_ids = [aws_security_group.pubSG1.id]

    tags = {
        Name = "pub-server"
    }
 }

 resource "aws_instance" "db" {
    ami = var.ami_id
    instance_type = var.instance_type
    associate_public_ip_address = true
    subnet_id = aws_subnet.subpvt.id
    vpc_security_group_ids = [aws_security_group.pvtSG4.id]

    tags = {
        Name = "pvt-server"
    }
 }

output natpubip {
    value = "aws_nat_gateway.nat1.public_ip"
    description = "shows the output of PUBIP"
}
