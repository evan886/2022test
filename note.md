
# 创建 vm (ec2) 及其它配置 os  
 Use Terraform or Ansible or CloudFormation to automate the following tasks against any cloud provider platform,  e.g. AWS, GCP, Aliyun.
 Provision a new VPC and any networking related configurations.  
 In this environment provision a virtual machine instance, with an OS of your choice.

利用 terraform 
 详情请见  https://github.com/evan886/2022test/tree/main/terraform-aws


# Apply any security hardening (OS, firewall, etc..) you see fit for the VM instance
  利用 TCP Wrappers 在跑 install docker 时加了指定可ssh的ip 
   sudo sed  -i '$a\sshd:61.140.169.212,138.68.59.0'  /etc/hosts.allow
   sudo sed  -i '$a\sshd:ALL' /etc/hosts.deny

# Install Docker CE on that VM instance.
  利用 ansible-playbook 进行安装
 https://github.com/evan886/2022test/blob/main/ansible/insdocker.yml
 https://github.com/evan886/2022test/tree/main/ansible/roles/insdocker

# Deploy/Start an Nginx container on that VM instance.
  Demonstrate how you would test the healthiness of the Nginx container.
  Expose the Nginx container to the public web on port 80.


  也是利用 ansible-playbook
 https://github.com/evan886/2022test/blob/main/ansible/insng.yml

 https://github.com/evan886/2022test/tree/main/ansible/roles/insng

#  Fetch the output of the Nginx container’s default welcome page.
  Excluding any HTML/JS/CSS tags and symbols, output the words and their frequency count for the words that occurred the most times on the default welcome page.
 脚本 请见 
 https://github.com/evan886/2022test/blob/main/py3count.py

 ansible ec2  -m script -a ' ./py3count.py'

* Demonstrate how you would log the resource usage of the containers every 10 seconds.

 cat  10.sh 
 watch -n 10 "sudo  docker stats nginx1.15  --no-stream "

 ansible ec2  -m script -a ' ./10.sh'

#!/bin/bash
while [ true ]
do
/bin/sleep 10
date >>dockerngstats
sudo  docker stats nginx1.15  --no-stream >>dockerngstats
done

#或者放在 crontab 
