variable prj_name {
    type = string
    default= "hellobaghub"
}

variable common_tags {
    type = map(string)
    default= {tags="team1-bag-prj"}
}

variable ec2_create {
    type = bool
    default =false
}


variable vpc_create {
    type = bool
    default =true
}

variable main_public_subnet_cidr{
    type = list(string)
    default = ["10.0.1.0/24"]
}

variable main_private_subnet_cidr {
    type = list(string)
    default = ["10.0.2.0/24"]
}

variable all_access {
    type = string
    default = "0.0.0.0/0"
}

variable ec2_mater{
    type = map(string)
    default = {
        name = "master-svr",
        ami = "ami-01938df366ac2d954",
        instance_type = "t2.medium"
    }
}

variable ec2_worker{
    type = map(string)
    default = {
        name = "worker-svr",
        ami = "ami-01938df366ac2d954",
        instance_type = "t2.micro"
    }
}

variable ec2_jumphost{
    type = map(string)
    default = {
        name = "jumphost",
        ami = "ami-01938df366ac2d954",
        instance_type = "t2.micro"
    }
}

variable "private_key" {
  description = "Private keypair content to access AWS"
  type        = string
  sensitive   = true
}

variable "hellobag_keypair" {
  type        = string
  default = ""
}

variable "ssh_ingress_cidrblock"{
    type = list(string)
    default = ["0.0.0.0/0"]
}

variable "ssh_egress_cidrblock"{
    type = list(string)
    default = ["0.0.0.0/0"]
}

variable "pod_network_cidr"{
    type = string
    default = "192.168.0.0/16"
}

