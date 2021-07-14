output "k8s-az1-node_public-ip" {
  value = {
    for instance in aws_instance.k8s-nodes-az-1 :
    instance.id => instance.public_ip
  }
}

output "k8s-az2-node_public-ip" {
  value = {
    for instance in aws_instance.k8s-nodes-az-2 :
    instance.id => instance.public_ip
  }
}

output "k8s-az3-node_public-ip" {
  value = {
    for instance in aws_instance.k8s-nodes-az-3 :
    instance.id => instance.public_ip
  }
}