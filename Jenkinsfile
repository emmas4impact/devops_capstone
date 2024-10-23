pipeline {
    agent { label 'jenkins-slave' }
    environment {
            PATH = "${env.PATH}:/usr/bin"
            USE_GKE_GCLOUD_AUTH_PLUGIN = 'True'
            VERSION = "${env.BUILD_NUMBER}"
            KUBECONFIG = '/home/ubuntu/.kube/config'
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Package') {
            steps {
                sh 'mvn package'
            }
        }
        stage('Build and Push Docker Image to DockerHUB') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials-id', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                        sh 'docker build -t emmas4impact/abc-technologies .'
                        sh 'docker push emmas4impact/abc-technologies'
                        echo "done"
                    }

                }
            }
        }
        stage('Pull image from dockerhub and start container with Ansible') {
            steps {
                script {
                    sh '''
                        ansible-playbook -i ./ansible/inventory.ini ./ansible/docker-playbook.yaml
                    '''
                }
            }
        }
        stage('Deploy k8s manifest with Ansible to kubernetes') {
                steps {
                    script {
                        sh 'ansible-playbook -i ./ansible/inventory.ini ./ansible/k8s-playbook.yaml'
                    }
                }
        }
        stage('Deploy Prometheus & Grafana with Ansible') {
            steps {
                script {
                    sh 'ansible-playbook -i ./ansible/inventory.ini ./ansible/main-playbook.yaml'
                }
            }
        }
}
}