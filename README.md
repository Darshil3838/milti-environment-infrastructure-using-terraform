# milti-environment-infrastructure-using-terraform


         ___        ______     ____ _                 _  ___  
        / \ \      / / ___|   / ___| | ___  _   _  __| |/ _ \ 
       / _ \ \ /\ / /\___ \  | |   | |/ _ \| | | |/ _` | (_) |
      / ___ \ V  V /  ___) | | |___| | (_) | |_| | (_| |\__, |
     /_/   \_\_/\_/  |____/   \____|_|\___/ \__,_|\__,_|  /_/ 
 ----------------------------------------------------------------- 



1.	Create two s3 buckets 1) acs730-dev-drdobariya and 2) acs730-prod-drdobariya
2.	Create a cloud9 environment -> ACS730-Assign
3.	Create a new folder -> "modules" 
4.	Create two more folders within modules 1) aws_network and 2)globalvars.
5.	Inside the aws_network make three files 1)main.tf, 2)output.tf, and 3)variables.tf.
6.	In main.tf define the 1)provider, 2)data source for availability zones, 3)local variables, 4)vpc definition for non prod(dev), 5)two private subnets for non prod, 6) two public subnets for vpc non prod, 7) internet gateway, 8) elastic ip for nat gateway, 9) NAT gateway, 10)public and private route table for non prod vpc, 
7.	In output.tf add output for 1)vpc id for non prod, 2)private subnet ids, 3)public subnet ids, 4)nat gateway, 5)Internet gateway, 6)eip id, 7)public route table id, 8)private route table id, 9)public cidr blocks and, 10)private cidr blocks.
8.	In variable.tf create variables for 1)default tags, 2)prefix, 3)private cidr, 4)public cidr, 4)env, and 5)availability zone(az)
9.	In globalvars folder, create a file output.tf. And add outputs of 1)default tags, 2)prefix
10.	Create a new folder with the name "week6" in the root directory. Inside it create three folders 1)dev(nonprod), 2)prod, and 3)Peering
11.	Inside dev folder create two folders 1)network, and 2)webserver
12.	In network folder of dev and prod create four files with the name 1)main.tf, 2)config.tf, 3)output.tf and 4)variables.tf.
13.	In webserver of dev and prod create create five files with the name 1)main.tf, 2)config.tf, 3)output.tf, 4)variables.tf, and 5) shell script for webserver
14.	In config.tf create a backend s3 for saving the terraform_remote_state inside s3 bucket we created. For store data in s3 bucket.
15.	In dev-network  
    1)In main.tf of folder add module of aws_network and specify its source, and call everything in that we created in aws_network main file. 
    2) in variable .tf create variables for 1)deafault tags, 2)prefix, 3)private subnet cidr blocks, 4)public subnet cidr blocks, 6)vpc cidr block, and 7)env
    3) In output.tf add output for 1)vpc id for non prod, 2)private subnet ids, 3)public subnet ids, 4) eip id, 5) public cidr blocks, 6)private cidr blocks, 7)nat gateway, 8)Internet gateway, 9)public route table id, and 9)private route table id.

16.	In dev-webserver
    1)	In main.tf define the 1)provider, 2)AMI id, 3)data source for availability zones, 4) remote state to retrieve the data, 5)local variables, 4)webserver1, 5)webserver2, 6)add ssh key pair, 7) Security Group For ws1 and ws2, 8)bastion, and 9) Security Group for bastian
    2)	In variable .tf create variables for 1) instance type, 2)default tags, 3)az, 4)prefix, and 5)env
    3)	In output.tf add output for 1) public ip of bastion, 2)private ip of ws1, and 3)private ip of ws2
 

17.	In prod-network  
    1) In main.tf define the 1)provider, 2)data source for availability zones, 3)local variables, 4)vpc definition for prod(dev), 5)two private subnets for prod.
    2) in variable .tf create variables for 1)deafault tags, 2)prefix, 3)private subnet cidr blocks, 4)vpc cidr block, and 5)env
    3) In output.tf add output for 1)vpc id for prod, 2)private subnet ids, 3)private cidr blocks, 4)vpc cidr

18.	In prod-webserver
    1)	In main.tf define the 1)provider, 2)AMI id, 3)data source for availability zones, 4) remote state to retrieve the data, 5)local variables, 4)webserver1, 5)webserver2, 6)add ssh key pair, 7) Security Group For ws1 and ws2
    2)In variable.tf create variables for 1)instance type, 2)default tags, 3)az, 4)prefix, and 5)env
    3) In output.tf add output for 1)private ip of ws1, and 2)private ip of ws2

19.	In Peering create main.tf file and inside of it define 1) provider, 2) remote state for dev and non-prod, 3)vpc peering connection between dev and prod, 4)route tables to establish connection between prod and non prod


To run this code terraform apply --auto-approve should run in this sequence
1)	dev network
2)	dev webserver
3)	Prod network
4)	Prod webserver
5)	Peering

For cleanup use terraform destroy --auto-approve in the reversal sequence. Which is navigate from Peering to dev network.





