# ANSIBLE

## Initialize

> To initialize this project you'll need python3.9 installed. Create a python virtual environment and use it to install the requirements:

### Install packages

```shell,python

# Install python 3.9, no commands provided hit the python oficial web site

#Create  a virtual environment and activate it
python3.9 -m venv .ansible_venv

source  .ansible_venv/bin/activate

# Install the python packages
pip install -r requirements.txt


# Install aws_cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install && rm -rf aws*


# Install needed ansible galaxy collections
ansible-galaxy collection install amazon.aws community.general ansible.posix
```

### Set your aws credentials

> For this step, you will need to create the vault/aws_credentials.yml vars file with the following data:

```yaml
---

accesskey: 
secretkey: 
rds_user: 
rds_password: 
efs_creation_token: 
...

```

> Have in mind that you'll need appropriated privileges to create  resources on AWS
