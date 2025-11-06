# Create VPC Infrastructure (Task 1)

## Project Overview
This project demonstrates the complete setup of a **custom AWS Virtual Private Cloud (VPC)** infrastructure using **Terraform**. The goal is to create a secure, scalable, and production-ready networking environment that supports public and private subnets, routing, NAT configuration, and private service connectivity via VPC Endpoints. Additionally, the project enables **VPC Flow Logs** for monitoring network traffic and stores them in **Amazon S3** for auditing and analysis.

This repository can serve as a foundational Infrastructure-as-Code (IaC) template for real-world AWS network designs.

---

## Architecture Diagram

![Architecture Diagram](Task0%20(1).jpg)

---

## Project Components

### **1. Custom VPC Creation**
- Creates a **VPC** with CIDR block `10.0.0.0/16`.
- Provides full control over subnets, routing, and access management.
- Default tenancy with no IPv6 configuration.

---

### **2. Subnet Design**
- **Four subnets** deployed across two availability zones for high availability:
  - `Public-SubnetA` (10.0.1.0/24)
  - `Private-SubnetA` (10.0.2.0/24)
  - `Public-SubnetB` (10.0.3.0/24)
  - `Private-SubnetB` (10.0.4.0/24)
- Public subnets host internet-facing EC2 instances.
- Private subnets host internal resources and applications that access the internet via a **NAT Gateway**.

---

### **3. Internet Connectivity**
- An **Internet Gateway (IGW)** is created and attached to the VPC.
- Public subnets are routed to the IGW for outbound internet access.

---

### **4. NAT Gateway Configuration**
- A **NAT Gateway** is deployed in `Public Subnet A`.
- Allocates an **Elastic IP (EIP)** for stable external connectivity.
- Private subnets route their outbound traffic through the NAT Gateway, ensuring secure internet access for internal instances.

---

### **5. Routing Configuration**
- **Public Route Table:**
  - Routes `0.0.0.0/0` traffic to the Internet Gateway.
- **Private Route Table:**
  - Routes `0.0.0.0/0` traffic to the NAT Gateway.
- Each subnet is associated with its corresponding route table.

---

### **6. EC2 Instance Deployment**
- EC2 instances are launched in both public and private subnets:
  - **Public Instances:** Web servers running NGINX, accessible via HTTP and SSH.
  - **Private Instances:** Internal instances accessible through **AWS Systems Manager Session Manager (SSM)** instead of SSH.
- Instances in private subnets use the **AmazonSSMManagedInstanceCore** IAM policy for SSM connectivity.

---

### **7. Security Groups**
- **Public Instance SG:**
  - Allows inbound HTTP (80), SSH (22), ICMP (ping), and HTTPS (443).
- **Private Instance SG:**
  - Allows ICMP (for ping), HTTPS (443), and outbound access for updates and SSM communication.
- Egress rules are fully open (`0.0.0.0/0`) to enable outbound communication.

---

### **8. VPC Flow Logs**
- **VPC Flow Logs** capture inbound and outbound traffic at the VPC level.
- Logs are stored in **CloudWatch Logs** for monitoring and troubleshooting.
- Configuration includes:
  - Filter: All traffic
  - Aggregation interval: 10 minutes
  - Log format: AWS default

---

### **9. VPC Gateway Endpoint for S3**
- A **VPC Gateway Endpoint** is created for **Amazon S3**.
- Allows instances in private subnets to access S3 directly **without routing through the NAT Gateway**.
- Enhances security and reduces NAT Gateway data transfer costs.

---

### **10. Elastic IP (EIP) Allocation**
- EIPs are allocated and attached to:
  - The **NAT Gateway**
  - Public-facing EC2 instances
- Ensures persistent public IPs for stable connectivity.

---

### **11. Connectivity Testing**
- **Public Instances:**  
  - Test by pinging `www.google.com` and accessing the NGINX webserver via browser using the EIP.
- **Private Instances:**  
  - Access via AWS Session Manager.
  - Ping tests validate routing through the NAT Gateway.
- **VPC Flow Logs:**  
  - Verified via CloudWatch Log Groups for traffic analysis.

---

## ⚙️ How to Deploy

### **Prerequisites**
- AWS Account with IAM credentials configured.
- Terraform installed (`>= v1.5.0` recommended).
- AWS CLI configured.

### **Steps**
1. Clone this repository:
   ```bash
   git clone https://github.com/zaeemattique/vpc-infrastructure-terraform.git
   cd vpc-infrastructure-terraform
