<span style="color: yellow"> In here Infrastructure is provision by a Terraform and configuration management part is doing by Ansible. </span>

# Provision infrastructure

With Terraform it creates one t2.micro instance with all the VPC related prerequisites as below.

* 1 VPC.
* 4 Subnets (Two Private & Two Public).
* 2 Route Tables.
* One Internet Gateway.
* One Security Group. <span style="color: blue">(allows traffic from anywhere for port 80,443,8090 and allows only the traffic from local IP for port 22)</span>
* One EC2 Instance.
* ssh key file.

All the variables related to the infrastructure provisioning are stored in a file named "variables.tfvars". You can change the some aspects of infrastructure by changing variables inside it.

variable file is as below.

```sh
#access_key              = " "
#secret_key              = " "

region                  = "ap-southeast-2"
name                    = "TEST-APP"  
azs                     = ["ap-southeast-2a","ap-southeast-2b"]
vpc_cidr                = "172.20.0.0/16"
public_subnet_cidr01    = "172.20.1.0/24"
public_subnet_cidr02    = "172.20.2.0/24"
private_subnet_cidr01   = "172.20.3.0/24"
private_subnet_cidr02   = "172.20.4.0/24"
host_count              = "1"
instancetype            = "t2.micro"
ami_id                  = "ami-0e040c48614ad1327"
```

With below commands you can manually provision only the infrastructure.
```
terraform -chdir="./Terraform/terraform/" init
terraform -chdir="./Terraform/terraform/" apply -auto-approve -var-file=variables.tfvars
```

After it completes the infrastructure provision, it produces an inventory file which is use by the ansible playbook for the application configuration.

Inventory file is as below.
```
[app_hosts]
host1 ansible_host=52.62.22.15 ansible_connection=ssh host_name=ip-172-20-1-165.ap-southeast-2.compute.internal
```

# Server and app configuration

Configuration part is totally done by Ansible. Whole configuration is doing by single play book. But there is 5 roles as below to do separate tasks.

- install-docker
- run-nginx
- nginx-watcher
- log-search-api
- iptables

## Tasks done by each role are as below
### install-docker
This role's primary responsibility is to install docker in a host machine. To run a docker container in a host machine, it installs some prerequisites as well.


### run-nginx
This role starts nginx docker image which is directly downloads from docker hub and mount a volume to a docker container to display a log file which is created by "nginx-watcher" as a web page.
```
image: nginx:stable
```

### nginx-watcher
Responsibility of this role is to deploy nginx container watcher script on a host EC2 instance and start it as a demon. That script produces log entry in every 10 seconds as below, which contains nginx server health and nginx docker containers resource usage.
```
Date:20220901_053155 - Service:Nginx - Status:Healthy - CONTAINER:nginx - CPU%:0.00% - Mem_Usage%:3.531MiB / 967.9MiB - NetIO:437kB / 28.4MB - BlockIO:5.39MB / 12.3kB
```

### log-search-api
This role is downloading log search api docker image from the docker hub which was uploaded by me and deploy it on a host machine.

Log search api scripts code repo.
```
https://github.com/surangar/log-search-api-server
```
Public Docker Image.
```
sesirir/log-search-api:latest
```
It works as an api server and you can search an entry on log file written by "nginx-watcher" script with curl command as below.
```
 curl -X POST -H “Content-Type: application/json” PUBLIC_IP:8090/getlogs -F 'date=ANY_TIME_STAMP_SHOWING_ON_LOG'

 Ex: 
 curl -X POST -H “Content-Type: application/json” 52.62.22.15:8090/getlogs -F 'date=20220901_120903'
```
### iptables
This role blocks all unwanted connections from OS level. It allows only a few ports ```(80,443,22,8090) ```. But not totally blocking internet access capability of the host machine since it accessing docker hub and some other sources.


With below command you can run only the app configuration related ansible part. without running infrastructure provisioning terraform part.
```
cd Ansible;export ANSIBLE_SSH_RETRIES=10 && ansible-playbook config-test-app.yml
```

# Deploy full application with both infrastructure and app configuration.

```deploy_app.sh``` shell script runs both infrastructure provisioning terraform code and ansible playbook sequentially. So it deploys whole application on a single run.
In the middle of the run it requests for a AWS credentials. 

<span style="color: red"> In the first run it deploys the application and in the second run it deleting the application. </span>

After a completion of the run, It displays public ip of the host in the output. You can directly put it on a web browser to access the nginx web service or for the api server accessing curl requests.

you can run deployment shell script as below.
```
./deploy_app.sh 
```