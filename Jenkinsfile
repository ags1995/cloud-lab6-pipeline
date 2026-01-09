pipeline {
    agent any
    
    environment {
        TF_VAR_password = credentials('openstack-password')
        ARTIFACT_PATH = 'target/*.jar'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Java Application') {
            steps {
                sh 'mvn -B -DskipTests clean package'
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
        
        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform plan'
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                    script {
                        env.INSTANCE_IP = sh(
                            script: 'terraform output -raw instance_ip',
                            returnStdout: true
                        ).trim()
                    }
                }
            }
        }
        
        stage('Ansible Configuration') {
            steps {
                dir('ansible') {
                    // Copy built artifact for deployment
                    sh 'cp ../target/*.jar files/application.jar'
                    
                    // Create inventory with Terraform output
                    sh """
                        echo "[lab_servers]" > inventory.ini
                        echo "${env.INSTANCE_IP} ansible_user=ubuntu ansible_ssh_private_key_file=/jenkins/.ssh/id_rsa" >> inventory.ini
                    """
                    
                    // Run Ansible playbook
                    sh 'ansible-playbook -i inventory.ini playbook.yml -e "artifact_path=files/application.jar"'
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                script {
                    sh "curl -f http://${env.INSTANCE_IP}:8080/health || echo 'Application starting...'"
                }
            }
        }
    }
    
    post {
        always {
            echo "Lab 5 pipeline completed"
            // Optional: Cleanup or notifications
        }
        failure {
            // Optional: Rollback or alert
            dir('terraform') {
                sh 'terraform destroy -auto-approve || true'
            }
        }
    }
}
