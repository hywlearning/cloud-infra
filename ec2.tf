data "aws_ami" "ubuntu" {
  count = var.vpc_create && var.ec2_create ? 1 : 0
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_instance" "jumphost" {
  count       = var.ec2_create && var.vpc_create ? 1 : 0 
  ami           = data.aws_ami.ubuntu[0].id
  instance_type = var.ec2_jumphost.instance_type
  subnet_id = aws_subnet.public[0].id
  key_name = var.hellobag_keypair
  vpc_security_group_ids = [aws_security_group.sg_jumphost[0].id]
  associate_public_ip_address = true
  
  tags = merge(
    { Name = "${var.prj_name}-jumphost-ec2}"},
      var.common_tags
  )
}

resource "aws_instance" "master" {
  count       = var.ec2_create && var.vpc_create ? 1 : 0 
  ami           = data.aws_ami.ubuntu[0].id
  instance_type = var.ec2_mater.instance_type
  subnet_id = aws_subnet.private[0].id
  key_name = var.hellobag_keypair
  vpc_security_group_ids = [aws_security_group.sg_master[0].id]
  associate_public_ip_address = false
  user_data = templatefile("${path.module}/templates/master.sh.tpl", {pod_networkd_cidr = var.pod_network_cidr})
  root_block_device {
    volume_size = 20          # Size in GiB
    volume_type = "gp3"       # Volume type (SSD)
    delete_on_termination = true  # Delete when instance terminates
  }
  tags = merge(
    { Name = "${var.prj_name}-master-ec2}"},
      var.common_tags
  )
}

resource "aws_instance" "worker" {
  count       = var.ec2_create && var.vpc_create ? 1 : 0 
  ami           = data.aws_ami.ubuntu[0].id
  instance_type = var.ec2_worker.instance_type
  subnet_id = aws_subnet.public[0].id
  key_name = var.hellobag_keypair
  vpc_security_group_ids = [aws_security_group.sg_worker[0].id]
  associate_public_ip_address = false
  user_data = templatefile("${path.module}/templates/worker.sh.tpl", {pod_networkd_cidr = var.pod_network_cidr,master_ip=aws_instance.master[0].private_ip})
  root_block_device {
    volume_size = 4          # Size in GiB
    volume_type = "gp3"       # Volume type (SSD)
    delete_on_termination = true  # Delete when instance terminates
  }
  tags = merge(
    { Name = "${var.prj_name}-worker-ec2}"},
      var.common_tags
  )
}