pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "us-east-2"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Sanjaymavi/Terraform-AWS-EKS-Cluster.git'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    bat 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    bat 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    bat 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Approval') {
            steps {
                input message: 'Approve Terraform Apply?'
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    bat 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Approval - Terraform Destroy') {
            steps {
                input(
                    message: '⚠️ DANGER ZONE ⚠️\nThis will DESTROY ALL AWS resources created by Terraform.\nDo you really want to continue?',
                    ok: 'Yes, Destroy Everything'
                )
            }
        }

        stage('Terraform Destroy') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    bat 'terraform destroy -auto-approve'
                }
            }
        }    
    }

    post {
        failure {
            echo 'Terraform deployment failed!'
        }
        success {
            echo 'Terraform deployment successful!'
        }
        always {
            input message: 'Do you want to DESTROY the infrastructure?'
            bat 'terraform destroy -auto-approve'
         }
    }
}
