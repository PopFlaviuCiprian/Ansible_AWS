# Terraform - Ansible - AWS - Docker

# Requirements for local host:

- Ansible 
- Terraform

# Install Ansible and Terraform in this case Debian ditribution
- to install Ansible run the commands: 
'''
sudo apt update
sudo apt install ansible
'''
- to install Terraform
- https://developer.hashicorp.com/terraform/install
- chose the version dependind on your OS
- in my case i download the binary file for Linux 
- unzip the file 
'''
unzip terraform_1.7.1_linux_amd64.zip
'''
- move the unzipped file to the folder /usr/local/bin
'''
sudo mv terraform /usr/local/bin
terraform --version
'''
- now the version should be desplayed 
- output: Terraform v1.7.1 on linux_amd64

## Project Description

- In this project i use terraform to create an infrastructure as follow:
- Build 4 EC2 instances: provider: AWS, region: eu-central-1, instances: 4, type: t2.micro, on inbound connection allow ssh.

- I create with terraform the infrastructure and configure with ansible localy on my pc, to install ansible on one Ec2 instance in AWS that will be the controller of the nodes and at the same time install docker on 3 nodes 
- I tag instances: controller_node, node1, node2, node3
- I generate a key, copy the key-pem to local pc and the same time include copying the key to the controller_node for later use to connect to nodes  
- I connect to controller_node instance from my local host
'''
ssh -i "private-key_name.pem" ec2-user@instance-ip , to test the ssh connection
'''
- if it is necessary to restrict the access to the key we run this command
'''
chmod 600 "name_key.pem"
'''
- I create a inventory file on my local pc with the hosts that will contain all the ip's where i want to install  ansible and docker.

- I create a playbook that contains all the tasks: on controller_node install ansible and on nodes 1,2,3 install docker, where docker will pull an image from my repository in docker-hub and create a container and run one the container on each node.

- the project structure is shown bellow

final_project_devops
├── ansible_key_frankfurt.pem         ( ssh_key_file for conecting to the controler_node and nodes 1, 2, 3 )
├── backup_folder                     ( name of the backup folder )
│   ├── ansible_key_frankfurt.pem
│   ├── hosts.ini                     ( inventory file with all the hosts )
│   ├── install_packages_v2.yml       ( playbook file with all the tasks )
│   ├── main.tf                       ( terrraform file containing all the infrasctucture configuration )
│   └── sensitive_info.yaml           ( encripted file with the credentials from docker hub )
├── hosts.ini
├── install_packages_v2.yml
├── main.tf
├── sensitive_info.yaml
├── terraform.tfstate
└── terraform.tfstate.backup

- the files appear 2 times because i always work with a backup_folder ( and of course the "key.pem" will not appear in github for security reasons ) 

- After i created all the files with configurations and tasks and hosts we proceed to start process of  buildind the infrastructure:
 Running the following commands:
 
'''
terraform init
terraform fmt
terraform plan
terraform apply
'''
'''
terraform destroy
'''

### Command description

- terraform init -Install all the plugins necessary for this project
- terraform fmt - rearange the code in a more organised way
- terraform plan - actually see all the project plan
- terraform apply - this command will build our instances on AWS 
- terraform destroy - command used to destroy all the project from the ground, removes all the instances on AWS but verry important: Our local files remain intact so we can reuse the code. 

- after running "terraform apply" command, our ec2 instances on AWS are created, we will have the ip's for all hosts from inventory file and we have to modiffy the "hosts.ini" file with the right ip's from our session.

if we want that ansible from our local host to controll all the nodes and controller_node we have to check the conectivity with command ping all the hosts in inventory file running the command: 

'''
ansible -i hosts.ini -m ping all
'''
'''
- if everithing it's ok and we have ping ok, we can run execute the playbook

'''
ansible-playbook -i hosts.ini  install_packages_v2.yml --ask-vault-pass
'''

'''
- after running all the congiguration files we can check by connect with ssh to controller_node to see if we have ansible installed and the key is present:
'''
ssh -i name_of_key.pem ec2-user@controller_node_ip 
'''

- from controller_node we can connect using the key.pem to access the nodes
'''
ssh -i key_name.pem ec2-user@node1_ip
ssh -i key_name.pem ec2-user@node2_ip
ssh -i key_name.pem ec2-user@node3_ip
'''

- and see if we have docker installed, if we have a docker image and a running container

'''
sudo docker --version  
sudo docker image ls
sudo docker ps
'''