pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = "docker.io/yourdockerhubusername"   // DockerHub username
        IMAGE_NAME = "lab-site"                                // image name
        CREDENTIALS_ID = "dockerhub-creds"                      // Jenkins Credential ID
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${CREDENTIALS_ID}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    powershell '''
                    echo "Logging into Docker registry..."
                    docker login ${env.DOCKER_REGISTRY} -u $env:DOCKER_USER -p $env:DOCKER_PASS
                    '''
                }
            }
        }

        stage('Build Image') {
            steps {
                powershell '''
                echo "Building Docker image..."
                docker build -t ${env.DOCKER_REGISTRY}/${env.IMAGE_NAME}:${env.BUILD_NUMBER} .
                '''
            }
        }

        stage('Push Image') {
            steps {
                powershell '''
                echo "Pushing image to registry..."
                docker push ${env.DOCKER_REGISTRY}/${env.IMAGE_NAME}:${env.BUILD_NUMBER}
                docker tag ${env.DOCKER_REGISTRY}/${env.IMAGE_NAME}:${env.BUILD_NUMBER} ${env.DOCKER_REGISTRY}/${env.IMAGE_NAME}:latest
                docker push ${env.DOCKER_REGISTRY}/${env.IMAGE_NAME}:latest
                '''
            }
        }

    }

    post {
        success {
            echo "✅ Build & push completed successfully!"
        }
        failure {
            echo "❌ Build or push failed — check console output"
        }
    }
}
