pipeline {
    agent any

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
        stage('Build and Push Docker Image') {
            steps {
                script {
                  withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials-id', usernameVariable: 'emmas4impact', passwordVariable: 'DOCKER_PASSWORD')]) {
                         sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                  }

                    // Build the Docker image
                    sh 'docker build -t emmas4impact/retailer-app .'
                    sh 'docker push emmas4impact/retailer-app'
                    echo "done"
                }
            }
        }
    }
}
