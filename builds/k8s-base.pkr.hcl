
variable "build_uuid" {
  type = string
  default = "default"
}

data "amazon-ami" "centos7" {
  filters = {
    name                = "CentOS 7.9.2009 x86_64"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["125523088429"]
  region      = "us-east-1"
}


locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "amazon-ebs" "k8s-base" {
  ami_name      = "k8s-base-${local.timestamp}"
  instance_type = "t3.medium"
  region        = "us-east-1"
  source_ami    = "${data.amazon-ami.centos7.id}"
  ssh_username  = "centos"
  tags = {
    build-uuid = "${var.build_uuid}"
  }
}

build {
  sources = ["source.amazon-ebs.k8s-base"]

  provisioner "shell" {
    inline = ["sudo yum install -y python3"]
  }

  provisioner "ansible" {
    extra_arguments = ["-vvvv", "-b"]
    playbook_file   = "./builds/ansible_playbooks/k8s_base.yml"
    user            = "centos"
  }
}
