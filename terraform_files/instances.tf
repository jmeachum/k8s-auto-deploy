#Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "ssh-key" {
  provider   = aws.region
  key_name   = "k8s"
  public_key = file("~/.ssh/id_rsa.pub")
}

#Create EC2 in us-east-1
resource "aws_instance" "k8s-nodes-az-1" {
  provider                    = aws.region
  count                       = var.node-count
  ami                         = var.ami_id
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.k8s-sg.id]
  subnet_id                   = aws_subnet.subnet_1.id

  tags = {
    Name = join("-", ["k8s_az_1_node", count.index + 1])
  }
}

#Create EC2 in us-east-1
resource "aws_instance" "k8s-nodes-az-2" {
  provider                    = aws.region
  count                       = var.node-count
  ami                         = var.ami_id
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.k8s-sg.id]
  subnet_id                   = aws_subnet.subnet_2.id

  tags = {
    Name = join("-", ["k8s_az_2_node", count.index + 1])
  }
}

#Create EC2 in us-east-1
resource "aws_instance" "k8s-nodes-az-3" {
  provider                    = aws.region
  count                       = var.node-count
  ami                         = var.ami_id
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.k8s-sg.id]
  subnet_id                   = aws_subnet.subnet_3.id

  tags = {
    Name = join("-", ["k8s_az_3_node", count.index + 1])
  }
}