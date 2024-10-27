pipeline {
    agent any
    environment {
            PATH = "${env.PATH}:/usr/bin"
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
                    sh 'docker build -t emmas4impact/abc-technologies .'
                    sh 'docker push emmas4impact/abc-technologies'
                    echo "done"
                }
            }
        }
        stage('Deploy with Ansible') {
            steps {
                script {
                    sh '''
                        ansible-playbook -i ./ansible/inventory.ini ./ansible/docker-deploy.yaml
                    '''
                }
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
                        sh 'ansible-playbook -i ./ansible/inventory.ini ./ansible/k8s-deploy.yml'
                    }
                }
            }

    }
}