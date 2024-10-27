pipeline {
    agent any
    environment {
            PATH = "${env.PATH}:/usr/bin"
            USE_GKE_GCLOUD_AUTH_PLUGIN = 'True'
            VERSION = "${env.BUILD_NUMBER}"
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
                    }
                    sh "docker build -t emmas4impact/abc-technologies:${VERSION} ."
                    sh "docker tag emmas4impact/abc-technologies:${VERSION} emmas4impact/abc-technologies:latest"
                    sh "docker push emmas4impact/abc-technologies:${VERSION}"
                    sh "docker push emmas4impact/abc-technologies:latest"
                    echo "Docker image emmas4impact/abc-technologies:${VERSION} pushed successfully"
                }
            }
        }
        stage('Deploy with Ansible') {
            steps {
                script {
                    sh """
                        ansible-playbook -i ./ansible/inventory.ini ./ansible/docker-deploy.yaml --extra-vars 'VERSION=${version}'
                    """
                }
            }
        }
        stage('Verify File Paths') {
            steps {
                sh 'ls -R'
            }
        }
        stage('Setup GKE Authentication') {
               steps {
                   withCredentials([file(credentialsId: 'gke-service-account', variable: 'SERVICE_ACCOUNT_JSON')]) {
                        sh 'gcloud auth activate-service-account --key-file=$SERVICE_ACCOUNT_JSON'
                        sh 'gcloud config set project devop-final-439802'
                        sh 'gcloud container clusters get-credentials devop-captone --zone us-central1-a'
                  }
               }
        }

            stage('Deploy with Ansible to GKE') {
                steps {
                    script {
                        sh 'ansible-playbook -i ./ansible/inventory.ini ./ansible/k8s-deploy.yaml'
                    }
                }
            }

    }
}