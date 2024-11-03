# Network-Centric Multi-Tier services Cloud Infrastructure Deployement

## Introduction
This project focuses on designing, deploying, and optimizing a scalable, network-centric cloud infrastructure for multi-tier applications. It includes configurations for virtual networks, automated scaling, security measures, and core service setups (FTP, MySQL, HTTP). The goal is to create a secure, high-performing environment suited for retail and healthcare use cases, allowing for seamless scalability and effective resource management.

### Video Demonstration: 

[![Video Demonstration](https://github.com/gurkaran-singh1/Multi-Tier-Cloud-Infrastructure-Implementation-for-Web-and-Database-Services-/blob/main/images/CSproj.JPG)](https://seneca-my.sharepoint.com/:v:/g/personal/gurkaran-singh1_myseneca_ca/EYXyABG0-YRJltE3o7dFO6sBwy5IgAShqF4YBMYHMlrsvw?e=aKNKP7&nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJTdHJlYW1XZWJBcHAiLCJyZWZlcnJhbFZpZXciOiJTaGFyZURpYWxvZy1MaW5rIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXcifX0%3D)

---

## Table of Contents
- [Project Goal](#project-goal)
- [Setup Instructions](#setup-instructions)
  - [Prerequisites](#prerequisites)
  - [Configuration Files](#configuration-files)
  - [Deployment Steps](#deployment-steps)
- [IPTables and Configuration Commands](#iptables-and-configuration-commands)
- [Project Overview](#project-overview)
- [References](#references)

---

## Project Goal
The main objective of this project is to deploy and secure a multi-tier cloud architecture, emphasizing the following:
- Multi-VNET setup with network security and peering.
- Automated scaling using Docker and Kubernetes.
- Implementation of core services: FTP, MySQL, HTTP web server.

---

## Setup Instructions

### Prerequisites
- **Azure Account**: Ensure you have access to Azure services for deploying VMs, VNETs, and other resources.
- **Docker & Kubernetes**: Installed on Host VM for container management.
- **Git**: Installed on your local machine for cloning and version control.
- **SSH Key**: Generate a new SSH key pair for accessing VMs securely.

### Configuration Files
- **setup_config.sh**: Defines all variables for network creation.
- **network_functions.sh**: Contains functions to create VNETs, subnets, NICs, NSGs.
- **vm_functions.sh**: Functions for creating Windows Client and Ubuntu Host VMs.
- **cluster_resource_create.sh**: Script for creating Azure cluster resources.
- **app-host-sshkey.pub**: Public key for SSH access to Linux VMs.

### Deployment Steps

#### Step 1: Clone the Repository
```bash
git clone <repository-url>
cd <repository-folder>
```

#### Step 2: Generate SSH Key
Generate a new SSH key for secure VM access:
```bash
ssh-keygen -t rsa -b 2048 -f app-host-sshkey-15
cp app-host-sshkey-15.pub CSP451/CSP451-Scripts/cluster-scripts/app-host-sshkey.pub
```

#### Step 3: Update Configuration
Edit `setup_config.sh` with your Azure resource group, network, and IP details:
```bash
nano CSP451/CSP451-Scripts/cluster-scripts/setup_config.sh
```

#### Step 4: Create Cluster Resources
Run the cluster resource script to deploy VMs and networking components:
```bash
bash CSP451/CSP451-Scripts/cluster-scripts/cluster_resource_create.sh
```

#### Step 5: Verify Connections
- Use Azure Bastion or SSH to connect to the Client VM.
- SSH from the Client VM to the Host VM using the SSH key.

#### Step 6: Configure Docker, Kubernetes, and MySQL on Host VM
- **Docker Installation**:
  ```bash
  sudo bash CSP451-Scripts/cheat-sheet/docker_install.sh
  ```

- **Docker-Compose Installation**:
  ```bash
  sudo apt install docker-compose -y
  ```

- **MySQL Installation**:
  ```bash
  sudo apt-get install mysql-server -y
  ```

#### Step 7: Configure Core Services on Host VM
- FTP, MySQL, and HTTP services:
  ```bash
  sudo apt install vsftpd
  sudo apt install apache2
  sudo mysql_secure_installation
  ```

- **MySQL Configuration**:
  ```sql
  CREATE DATABASE employees;
  USE employees;
  CREATE TABLE employee (id INT PRIMARY KEY, first_name VARCHAR(50), last_name VARCHAR(50));
  ```

- **MySQL User Access**:
  ```sql
  GRANT ALL PRIVILEGES ON employees.* TO 'gsingh1'@'192.168.15.4';
  FLUSH PRIVILEGES;
  ```

---

## IPTables and Configuration Commands

Configure `iptables` on the Linux Router VM to allow specific traffic:

```bash
# Allow DNS
iptables -A FORWARD -p tcp -d 172.17.15.4 --dport 53 -j ACCEPT
iptables -A FORWARD -p udp -d 172.17.17.15.4 --dport 53 -j ACCEPT

# Allow MySQL
iptables -A FORWARD -p tcp -s 10.10.10.0/24 -d 172.17.15.5 --dport 3306 -j ACCEPT

# Allow HTTP (Apache)
iptables -A FORWARD -p tcp -s 10.10.10.0/24 -d 172.17.15.5 --dport 80 -j ACCEPT

# Allow FTP
iptables -A FORWARD -p tcp -s 10.10.10.0/24 -d 172.17.15.4 --dport 21 -j ACCEPT
iptables -A FORWARD -p tcp -s 10.10.10.0/24 -d 172.17.15.4 --dport 50000:51000 -j ACCEPT
```

To make these rules persistent:
```bash
sudo apt install iptables-persistent
sudo netfilter-persistent save
sudo netfilter-persistent reload
```

---

## Project Overview

This project demonstrates a robust network-centric cloud architecture setup using Azure, Docker, Kubernetes, and essential services (FTP, MySQL, HTTP). Through automated scaling, security configurations, and efficient network traffic management, the project achieves a resilient, scalable environment suitable for various enterprise applications.

## References


---

