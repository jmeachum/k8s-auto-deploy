variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "instance-type" {
  type    = string
  default = "t3.medium"
}

variable "node-count" {
  type    = number
  default = 2
}

variable "webserver-port" {
  type    = number
  default = 80
}

variable "dns-name" {
  type    = string
  default = "cmcloudlab1708.info."
}

variable "ami_id" {
  type = string
  default = "default"
}