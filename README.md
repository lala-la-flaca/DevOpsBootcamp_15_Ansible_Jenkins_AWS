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
  🧩 Configures multiple servers from a single pipeline.<br>
  

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
   <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_15_Ansible_Jenkins_AWS/blob/main/Img/1%20droplet.PNG" width=800 />
   
3. Launch two AWS EC2 instances to host the application.
   <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_15_Ansible_Jenkins_AWS/blob/main/Img/2%20aws%20ec2%20instances.PNG" width=800 />
  
5. Connect to the Droplet and update all system packages.

   ```
   ssh root@159.89.183.0
   apt update
   ```
   <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_15_Ansible_Jenkins_AWS/blob/main/Img/3%20apt%20update%20and%20install%20ansible.png" width=800 />
   
7. Install Ansible and the required Python dependencies: boto3 and botocore.
  
   ```
   apt install ansible-core
   apt install python3-boto3
   apt install python3-botocore
   ```
   <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_15_Ansible_Jenkins_AWS/blob/main/Img/4%20install%20boto3%20and%20botocore.png" width=800 />
   
9. Create the .aws directory and add a credentials file to store your AWS access keys.
  
   ```
   mkdir .aws
   cd .aws
   vim credentials
   ```
   <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_15_Ansible_Jenkins_AWS/blob/main/Img/5%20create%20aws%20hidden%20folder%20for%20credentials.png" width=800 />
   
## Jenkinsfile Configuration
1. Create a New branch in the Jenkins project's pipeline
  
2. Add a new Ansible directory to copy the files from the EC2-dynamic-inventory demo.
   
   <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_15_Ansible_Jenkins_AWS/blob/main/Img/7%20create%20an%20ansible%20folder%20and%20add%20the%20ansible%20files%20inside.png" width=800/>
   
3. Add a Jenkinsfile to define the pipeline stages.
   
   ```
     pipeline {   
      agent any
  
      environment{
          ANSIBLE_SERVER = "167.71.181.151"
          AWS_REGION = 'us-east-2'
      }
     
      stages {
     }
    }
   ```
   
4. Create a stage to copy the Ansible files to the target Droplet.
   ```
    stage("copy files to ansible server") {
            steps {
                script {
                   echo "copying all necessary files to Ansible server"
                   dir('java-maven-app'){

                        sshagent(['ansible-server-key']){  

                            //copying Ansible files to the remote droplet (Ansible server)
                            //Files: inventory, playbook, cfg                      
                            sh "scp -o StrictHostKeyChecking=no ansible/* root@${ANSIBLE_SERVER}:/root"

                            //Saving AWS PEM file in the keyfile variable
                            // keyFileVariable --> Creates a temporary file with the credentials, then this file is copied to the Ansible server
                            withCredentials([sshUserPrivateKey(credentialsId: 'ansible-ec2-key', keyFileVariable: 'keyfile', usernameVariable: 'user')]) {
                                //insecure because with "" groovy exposes the pem file in the command line
                                //sh "scp ${keyfile} root@${ANSIBLE_SERVER}:/root/ssh-key.pem"
                                //with single '', Groovy uses the secret differently and does not expose the file.
                                sh 'scp $keyfile root@$ANSIBLE_SERVER:/root/ssh-key.pem'
                            }                 

                        }
                   }

                }
            }
        }
   ```
   <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_15_Ansible_Jenkins_AWS/blob/main/Img/8%20jenkins%20file%20stage%20copy%20files%20to%20ansible%20server.png" width=800 />
   
5. Verify that the SSH Agent plugin is installed and available in Jenkins.
   <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_15_Ansible_Jenkins_AWS/blob/main/Img/9%20ssh%20plugin%20available%20in%20jenkins%20server.PNG" width=800 />
   
6. Add new credentials to store the SSH keys required for Ansible to access the EC2 instances.
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_15_Ansible_Jenkins_AWS/blob/main/Img/11%20add%20the%20ssh%20ansible%20key%20to%20access%20ec2.PNG" width=800 />
    
7. Create a new Jenkins pipeline and link it to the repository.
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_15_Ansible_Jenkins_AWS/blob/main/Img/12%20create%20a%20new%20jenkins%20pipeline.png" width=800 />
    
8. Install the SSH Pipeline plugin in Jenkins if it’s not already installed.
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_15_Ansible_Jenkins_AWS/blob/main/Img/13%20install%20plugin%20ssh%20pipeline.PNG" width=800 />
    
9. Add a second stage to run the Ansible playbook.
    ```
    stage("execute ansible playbook"){
            steps{
                script{
                   echo "executing ansible playbook to configure ec2" 

                    //using ssh pipeline plugin
                    //Defining remote object
                    def remote = [:]
                    remote.name = "ansible-server"
                    remote.host = "${ANSIBLE_SERVER}"
                    remote.allowAnyHosts = true

                     
                    withCredentials([
                        //using credentials to access the Ansible server
                        sshUserPrivateKey(credentialsId: 'ansible-server-key', keyFileVariable: 'keyfile', usernameVariable: 'user'),

                        //using credentials from AWS plugin
                        aws(credentialsId: 'unicorn-aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')
                    ]){
                            remote.user = user
                            remote.identityFile = keyfile
                            sshCommand remote: remote, command: "ls -l"
                            sshCommand remote: remote, command: 'echo "preparing ansible server:"'                            
                            sshCommand remote: remote, command: "ansible-playbook my-playbook.yaml"
                        }
                }
            }
        }
    ```
    
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_15_Ansible_Jenkins_AWS/blob/main/Img/14%20step%20execute%20ansible%20playbook.PNG" width=800 />
    
10. Check the console output to confirm that the pipeline executed successfully.
    
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_15_Ansible_Jenkins_AWS/blob/main/Img/15%20running%20playbook%20AWS%20OK.png" width=1000 />
    
11. Verify that Docker is installed and running on the EC2 instances.
    
    ```
    which docker
    ```
    <img src="https://github.com/lala-la-flaca/DevOpsBootcamp_15_Ansible_Jenkins_AWS/blob/main/Img/16%20docker%20installed.PNG" width=800 />
    

## Ansible Server Automation
To further automate the pipeline, we can automate the Ansible server configuration. As follows:
