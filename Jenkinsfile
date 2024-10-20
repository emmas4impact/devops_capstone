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
        stage('Build Docker Image') {
            steps {
                script {
//                     sh 'docker build -t your-dockerhub-username/your-app .'
//                     sh 'docker push your-dockerhub-username/your-app'
                    echo "done"
                }
            }
        }
    }
}
