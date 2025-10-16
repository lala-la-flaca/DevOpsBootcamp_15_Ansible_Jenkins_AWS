# <img width="80" height="80" alt="image" src="https://github.com/user-attachments/assets/1d67d697-03bf-466c-a71c-e118e5fd2614" /> Module 15 – Configuration Management with Ansible.

This exercise is part of Module 15 from the TWN DevOps Bootcamp. In Module 15, we focus on automating server setup and application deployment using Ansible. You learn how to configure servers, deploy Node.js and Nexus, integrate with Terraform and Jenkins, manage Docker containers, and organize playbooks with roles. Each demo builds practical automation skills for real-world DevOps environments.

---
<a id="demo7"></a>
# 📦Demo 7 – Ansible Integration in Jenkins
# 📌 Objective
Integrate Ansible execution into a Jenkins pipeline to automate the configuration of multiple EC2.


# 🚀 Technologies Used
* Ansible: Configuration management tool for automation.
* AWS: Cloud provider.
* Linux: OS.
* DigitalOcean: Cloud provider

# 🎯 Features
  ✅ Jenkins triggers remote Ansible playbooks.<br>
  🧩onfigures multiple servers from a single pipeline.<br>
  

# Prerequisites
* AWS account with valid keys.
* For Ansible controller node:
  * python >=3.6
  * boto3 >= 1.26.0
  * botocore >= 1.29.0
* Python modules require these dependencies to execute the K8 module:
  * python >= 3.6
  * kubernetes >= 12.0.0
  * PyYAML >= 3.11
  * jsonpatch
* DigitalOcean account.
* Demo from Dynamic Inventory
* Jenkins server from module 8.
  

# 🏗 Project Architecture
<img src="https://github.com/lala-la-flaca/DevOpsBootcamp_15_Ansible_Jenkins_AWS/blob/main/Img/Demo15-Jenkins.drawio.png" width=800 />



# ⚙️ Project Configuration
## Setting up Infrastructure 
1. Create a new DigitalOcean Droplet to host the Ansible control node.
   <img src="" width=800 />
   
3. Launch two AWS EC2 instances to host the application.
   <img src="" width=800 />
  
5. Connect to the Droplet and update all system packages.

   ```
   ```
   <img src="" width=800 />
7. Install Ansible and the required Python dependencies: boto3 and botocore.
  
   ```
   ```
   <img src="" width=800 />
9. Create the .aws directory and add a credentials file to store your AWS access keys.
  
   ```
   ```
   <img src="" width=800 />
   
## Jenkins File Configuration
1. Create a New branch in the Jenkins project's pipeline
   <img src="" width=800 />
   
3. Add a Jenkinsfile to define the pipeline stages.
   
5. Create a stage to copy the Ansible files to the target Droplet.
   ```
   ```
   <img src="" width=800 />
   
7. Verify that the SSH Agent plugin is installed and available in Jenkins.
   <img src="" width=800 />
   
9. Add new credentials to store the SSH keys required for Ansible to access the EC2 instances.
    <img src="" width=800 />
    
11. Create a new Jenkins pipeline and link it to the repository.
    <img src="" width=800 />
    
13. Install the SSH Pipeline plugin in Jenkins if it’s not already installed.
    <img src="" width=800 />
    
15. Add a second stage to run the Ansible playbook.
    ```
    ```
    <img src="" width=800 />
    
17. Check the console output to confirm that the pipeline executed successfully.
    <img src="" width=800 />
    
19. Verify that Docker is installed and running on the EC2 instances.
    <img src="" width=800 />
    

