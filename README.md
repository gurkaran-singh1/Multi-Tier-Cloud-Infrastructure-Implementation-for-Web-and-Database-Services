# Multi-Tier Cloud Infrastructure Implementation for Web and Database Services

---

## 1. Introduction

This project focuses on designing and configuring a **robust virtual network environment** that demonstrates the integration of multiple servers and services across a secure and controlled network. The primary goal is to build an interconnected system that uses a custom DNS server to manage network traffic and enable seamless communication between Windows and Linux servers. By setting up essential web, database, and file transfer services, along with carefully configured iptables firewalls, this project simulates a practical IT infrastructure with a focus on network security, traffic filtering, and service accessibility.

In this environment, a Windows Server (WS-15) is configured as a dedicated DNS server, managing the domain and providing name resolution for all connected virtual machines (VMs). Services such as IIS, FTP, Apache, and MariaDB are set up on the Windows and Linux servers, each configured with specific access permissions to simulate real-world user and network requirements. Additionally, custom iptables rules on a Router VM control and secure inter-server communication, selectively routing traffic between the client and server networks.

By the end of this project, the entire system will be tested for seamless connectivity, ensuring that each service is accessible only as intended and all configurations persist across system reboots. This structured approach to deploying and securing network services within a virtualized environment serves as an essential exercise in network administration, security configuration, and service management, reinforcing key skills needed in IT infrastructure management.

---

### Click here for the video demonstration

[![Video Demonstration](https://github.com/gurkaran-singh1/Multi-Tier-Cloud-Infrastructure-Implementation-for-Web-and-Database-Services-/blob/main/images/CSproj.JPG)](https://seneca-my.sharepoint.com/:v:/g/personal/gurkaran-singh1_myseneca_ca/EYXyABG0-YRJltE3o7dFO6sBwy5IgAShqF4YBMYHMlrsvw?e=aKNKP7&nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJTdHJlYW1XZWJBcHAiLCJyZWZlcnJhbFZpZXciOiJTaGFyZURpYWxvZy1MaW5rIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXcifX0%3D)

---

## Table of Contents

1. [Introduction](#introduction)
2. [Project Objectives](#project-objectives)
3. [Step-by-Step Instructions](#step-by-step-instructions)
   - 3.1 [Windows Server (WS-15) Configuration](#windows-server-ws-15-configuration)
     - 3.1.1 [DNS Server Setup](#dns-server-setup)
     - 3.1.2 [IIS Installation and Configuration](#iis-installation-and-configuration)
     - 3.1.3 [FTP Server Installation and Configuration](#ftp-server-installation-and-configuration)
   - 3.2 [Linux Server (LS-15) Configuration](#linux-server-ls-15-configuration)
     - 3.2.1 [Apache Web Server Setup](#apache-web-server-setup)
     - 3.2.2 [MariaDB Installation and User Configuration](#mariadb-installation-and-user-configuration)
     - 3.2.3 [iptables Firewall Configuration for Services](#iptables-firewall-configuration-for-services)
   - 3.3 [Router (LR-15) Firewall Configuration](#router-lr-15-firewall-configuration)
     - 3.3.1 [Basic Connectivity Rules](#basic-connectivity-rules)
     - 3.3.2 [Service-Specific Firewall Rules](#service-specific-firewall-rules)
     - 3.3.3 [Testing Firewall Rules](#testing-firewall-rules)
   - 3.4 [Client (WC-15) Configuration](#client-wc-15-configuration)
     - 3.4.1 [DNS Settings](#dns-settings)
     - 3.4.2 [Network Connectivity Tests](#network-connectivity-tests)
4. [Testing and Validation](#testing-and-validation)
   - 4.1 [Service Connectivity Testing](#service-connectivity-testing)
   - 4.2 [Firewall Rule Validation](#firewall-rule-validation)
   - 4.3 [Internet Access Verification](#internet-access-verification)
5. [Project Overview](#project-overview)

---

## 2. Project Objectives

Here’s an ordered list of the goals, from start to finish, to guide the project flow effectively:

**Configure a Custom DNS Server on Windows Server (WS-15):** 
Set up WS-15 as the primary DNS for the project environment.

**Update VM DNS Settings to Use Custom DNS Server:**
Configure all VMs to automatically use WS-15 as the primary DNS.

**Install IIS on Windows Server (WS-15):**
Install the IIS role and create a custom landing page that includes your name and student ID.

**Install and Configure FTP Server on Windows Server:**
Set up FTP on WS-15 with a custom data port range (50000-51000) and create two users with specified access levels.

**Configure DNS Forward Lookup Zone on Windows Server:**
In DNS Manager, create a forward lookup zone named "CSP451.com" and define A records for each VM.

**Set DNS Forwarder to 8.8.8.8 on Windows Server:**
Configure WS-15 to forward requests for non-local domains to 8.8.8.8.

**Install Apache on Linux Server (LS-15):**
Install and configure Apache on LS-15, adding a personalized default webpage.

**Install MariaDB on Linux Server (LS-15):**
Install MariaDB, create a read-only user, and verify database connectivity.

**Set Static Private IPs for All VMs:**
Ensure all VMs have static IP assignments to maintain consistent network connectivity.

**Disable Default Azure DNS Configurations on VMs:**
Remove any default DNS settings to ensure all traffic uses WS-15 as the DNS server.

**Update VNET DNS Settings to Point to WS-15:**
Configure the DNS settings on all VNETs to use WS-15 as the primary DNS server.

**Develop Basic iptables Firewall Rules on Linux Server (LS-15):**
Configure iptables to allow traffic only for installed services (Apache and MariaDB) on LS-15.

**Create Basic Connectivity Script on Router VM:**
Set up a basic iptables connectivity script on the Router VM to allow essential traffic between Client and Server networks.

**Add Service-Specific iptables Rules on Router VM:**
Define iptables rules on the Router VM to filter and route specific service traffic (DNS, MySQL, Apache, IIS, FTP) between networks.

**Test Firewall Rules Before Persisting on Router VM:**
Ensure that all iptables rules work as expected on the Router before making them persistent.

**Test Basic SSH and RDP Connectivity on Firewall (Router VM):**
Verify SSH and RDP access from the Desktop Client to LS-15 and WS-15.

**Verify HTTP and MySQL Traffic Routing from Client to Linux Server:**
Test HTTP and MySQL traffic flow from the Desktop Client to LS-15 using FQDN.

**Test HTTP, DNS, and FTP Traffic Routing from Client to Windows Server:**
Confirm that HTTP, DNS, and FTP traffic flows correctly from the Desktop Client to WS-15 using FQDN.

**Monitor Packet and Byte Counts on iptables Rules (Router and Linux Server):**
Verify traffic handling by checking packet and byte counts on iptables FORWARD rules in the Router and INPUT rules in LS-15.

**Confirm Internet Access for All VMs:**
Test that each VM can access external resources (e.g., downloading files) to validate internet connectivity and DNS settings.

Following this order will help build each component gradually, test connections and configurations along the way, and ensure the setup aligns with the milestone’s objectives.

---

## 4. Testing and Validation

### 4.1 Service Connectivity Testing
- Test the connectivity between the Desktop Client and each server (Windows Server WS-15, Linux Server LS-15) using their Fully Qualified Domain Names (FQDN).
- Ensure that HTTP traffic can reach the Apache web server on LS-15 and the IIS server on WS-15.
- Verify FTP service connectivity between the client and WS-15 by using the FTP client and connecting to the server with the configured port range (50000:51000).
- Check if the MariaDB service on LS-15 is accessible from the client and other servers.

### 4.2 Firewall Rule Validation
- Validate that iptables rules on the router (LR-15) allow the correct traffic (HTTP, FTP, MySQL) between the client and the servers.
- Confirm that firewall rules on both WS-15 and LS-15 permit access to the respective services (IIS, Apache, MariaDB, FTP).
- Use tools like `iptables -L` to list and verify the active firewall rules.
- Test if the correct ports are open and traffic is being routed as expected by monitoring packet counts.

### 4.3 Internet Access Verification
- Ensure that all VMs (WS-15, LS-15, WC-15, and LR-15) have internet access.
- Check if the DNS server is correctly forwarding queries to external servers, allowing VMs to access websites.
- Test internet connectivity on each VM by pinging an external server (e.g., `ping 8.8.8.8`).
- Verify that all VMs can download files from external HTTP servers and ensure proper network routing is in place for outbound traffic.

---

## 5. Project Overview

This project involves configuring a custom DNS server and deploying essential services such as web, FTP, and database on both Windows and Linux servers. It also includes setting up iptables firewall rules to manage traffic between the servers and clients. The goal is to ensure secure and reliable access to services across a controlled network environment. Key tasks include configuring DNS, web, FTP, and database services, along with enforcing security through firewall configurations. The project demonstrates skills in server setup, networking, and traffic management.

---

## Contributing

Feel free to suggest improvements, report issues, or ask for help! You can reach me out on my email or LinkedIn. (Link in bio)
