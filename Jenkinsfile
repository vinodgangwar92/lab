pipeline {
    agent { label 'windows' } 

    environment {
        DOCKER_REGISTRY = "docker.io/yourdockerhubusername"
        IMAGE_NAME = "lab-site"
        CREDENTIALS_ID = "dockerhub-creds"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${env.CREDENTIALS_ID}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    powershell '''
                    docker login ${env.DOCKER_REGISTRY} -u $env:DOCKER_USER -p $env:DOCKER_PASS
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                powershell """
                docker build -t ${DOCKER_REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER} .
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                powershell """
                docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER}
                docker tag ${DOCKER_REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER} ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest
                docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest
                """
            }
        }

    }

    post {
        success {
            echo "Docker built & pushed successfully!"
        }
        failure {
            echo "Docker build or push failed!"
        }
    }
}
