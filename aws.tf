data "aws_ami" "ubuntu" {
  count       = local.aws ? 1 : 0
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-18.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

resource "aws_key_pair" "this" {
  count      = local.aws ? 1 : 0
  key_name   = format("%s-%s", var.name, var.environment)
  tags       = var.tags
  public_key = file(format("%s/files/id_rsa.pub", path.module))
}

resource "aws_security_group" "this" {
  count       = local.aws ? 1 : 0
  name        = var.name
  description = title(var.name)
  vpc_id      = var.vpc_id
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}

module "aws_app" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 2.0"
  instance_count              = local.aws ? 1 : 0
  name                        = var.name
  ami                         = join("", data.aws_ami.ubuntu.*.id)
  instance_type               = local.instance_type[var.instance_size][local.cloud]
  associate_public_ip_address = true
  key_name                    = join("", aws_key_pair.this.*.key_name)
  user_data_base64            = local.user_data64
  monitoring                  = false
  vpc_security_group_ids      = aws_security_group.this.*.id
  subnet_id                   = var.subnet_id
  tags                        = var.tags
}
