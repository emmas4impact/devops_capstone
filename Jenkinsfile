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
                        export PATH=$PATH:/usr/bin
                        ansible-playbook -i inventory.ini docker-deploy.yaml
                    '''
                }
            }
        }
    }
}
