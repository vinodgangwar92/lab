pipeline {
    agent any

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

        stage('Login to Docker Registry') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${CREDENTIALS_ID}",
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
                powershell '''
                docker build --progress=plain -t ${DOCKER_REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER} .
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                powershell '''
                docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER}
                docker tag ${DOCKER_REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER} ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest
                docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:latest
                '''
            }
        }
    }

    post {
        success {
            echo "Docker build & push completed successfully!"
        }
        failure {
            echo "Docker build or push failed — please check logs."
        }
    }
}
