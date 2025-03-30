# JUMPHOST
resource "aws_security_group" "sg_jumphost" {
  count = var.ec2_create && var.vpc_create ? 1 : 0 
  name        = "${var.prj_name}-sg-jumphost"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main[0].id

   tags = merge(
    { Name = "${var.prj_name}-sg-jumphost" },
      var.common_tags
  )
}

resource "aws_security_group_rule" "sgr_ingress_jumphost" {
  count = var.ec2_create && var.vpc_create ? 1 : 0 
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.ssh_ingress_cidrblock
  security_group_id = aws_security_group.sg_jumphost[0].id
  description = "allow SSH "
}

resource "aws_security_group_rule" "sgr_egress_jumphost" {
  count = var.ec2_create && var.vpc_create ? 1 : 0 
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.ssh_egress_cidrblock
  security_group_id = aws_security_group.sg_jumphost[0].id
  description =  "allow all traffic for "
}
#Master
resource "aws_security_group" "sg_master" {
  count       = var.ec2_create && var.vpc_create ? 1 : 0 
  name        = "${var.prj_name}-sg-master"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main[0].id

  tags = merge(
    { Name = "${var.prj_name}-sg-master" },
      var.common_tags
  )
}

resource "aws_security_group_rule" "sgr_ingress_master" {
  count       = var.ec2_create && var.vpc_create ? 1 : 0 
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sg_master[0].id
  source_security_group_id = aws_security_group.sg_jumphost[0].id
  description = "allow SSH "
}

resource "aws_security_group_rule" "sgr_egress_master" {
  count       = var.ec2_create && var.vpc_create ? 1 : 0 
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.ssh_egress_cidrblock
  security_group_id =  aws_security_group.sg_master[0].id
  description =  "allow all traffic for "
}
#Worker
resource "aws_security_group" "sg_worker" {
  count       = var.ec2_create && var.vpc_create ? 1 : 0 
  name        = "${var.prj_name}-sg-workder"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main[0].id

  tags = merge(
    { Name = "${var.prj_name}-sg-worker" },
      var.common_tags
  )
}

resource "aws_security_group_rule" "sgr_ingress_worker" {
  count       = var.ec2_create && var.vpc_create ? 1 : 0 
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.sg_worker[0].id
  source_security_group_id = aws_security_group.sg_jumphost[0].id
  description = "allow SSH "
}

resource "aws_security_group_rule" "sgr_egress_worker" {
  count       = var.ec2_create && var.vpc_create ? 1 : 0 
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.ssh_egress_cidrblock
  security_group_id =  aws_security_group.sg_worker[0].id
  description =  "allow all traffic for "
}