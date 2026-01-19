pipeline {
    agent { label 'windows' }  // use a Windows agent that has Docker installed

    environment {
        REGISTRY = "docker.io/yourdockerhubusername"     // e.g., Docker Hub registry
        IMAGE_NAME = "lab‑site"                           // name for your image
        DOCKER_CREDENTIALS = "dockerhub‑creds"           // Jenkins credential ID
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
                    Write‑Host "Logging into Docker registry..."
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
                Write‑Host "Pushing image to registry..."
                docker push ${REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER}

                Write‑Host "Also tagging latest..."
                docker tag ${REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER} ${REGISTRY}/${IMAGE_NAME}:latest
                docker push ${REGISTRY}/${IMAGE_NAME}:latest
                """
            }
        }
    }

    post {
        success {
            echo "Docker build and push succeeded!"
        }
        failure {
            echo "Pipeline failed. Please check logs!"
        }
    }
}
