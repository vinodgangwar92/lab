pipeline {
    agent { label 'windows' }  // Use a Windows agent that has Docker installed

    environment {
        REGISTRY = "docker.io/yourdockerhubusername"   // your Docker Hub username
        IMAGE_NAME = "lab-site"                       // name for the image
        DOCKER_CREDENTIALS = "dockerhub-creds"        // Jenkins credential ID
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
                    credentialsId: "${env.DOCKER_CREDENTIALS}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    powershell '''
                    Write‑Host "Logging into Docker..."
                    docker login ${env.REGISTRY} -u $env:DOCKER_USER -p $env:DOCKER_PASS
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                powershell """
                Write‑Host "Building Docker image..."
                docker build -t ${REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER} .
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                powershell """
                Write‑Host "Pushing Docker image..."
                docker push ${REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER}

                Write‑Host "Tagging latest..."
                docker tag ${REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER} ${REGISTRY}/${IMAGE_NAME}:latest
                docker push ${REGISTRY}/${IMAGE_NAME}:latest
                """
            }
        }

    }

    post {
        success {
            echo "Docker image built & pushed successfully!"
        }
        failure {
            echo "Build/push failed — check the logs."
        }
    }
}
