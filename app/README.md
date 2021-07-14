# Automated K8s Deployment

This is an example of automating an app deployment into a HA K8s cluster using, Packer, Terraform, and Ansible.

## TODO:

1. Deploy APP to cluster.
2. Add ALB for APP with SSL and http redirect.
3. Add ALB to manage cluster with SSL and http redirect.
4. Remove public ip from nodes once deployed.
5. Add Bastion for ssh into nodes.
6. Add WAF for App Website.
7. Use of Hashicorp Vault to store keys and pull at runtime.
8. Add security monitoring infrastructure into another VPC. Audit d logs, waf logs, vault access logs.
9. Add operational monitoring infrastructure into another VPC.

