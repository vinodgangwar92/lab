pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = "docker.io/vinodgangwar92"
        IMAGE_NAME = "lab-site"
        CREDS = "dockerhub-creds"
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
                    credentialsId: "${CREDS}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    bat '''
                    docker login %DOCKER_REGISTRY% -u %DOCKER_USER% -p %DOCKER_PASS%
                    '''
                }
            }
        }

        stage('Build Image') {
            steps {
                bat '''
                docker build -t %DOCKER_REGISTRY%/%IMAGE_NAME%:%BUILD_NUMBER% .
                '''
            }
        }

        stage('Push Image') {
            steps {
                bat '''
                docker push %DOCKER_REGISTRY%/%IMAGE_NAME%:%BUILD_NUMBER%
                docker tag %DOCKER_REGISTRY%/%IMAGE_NAME%:%BUILD_NUMBER% %DOCKER_REGISTRY%/%IMAGE_NAME%:latest
                docker push %DOCKER_REGISTRY%/%IMAGE_NAME%:latest
                '''
            }
        }
    }

    post {
        success { echo "Docker build & push succeeded!" }
        failure { echo "Build or push failed — check logs." }
    }
}
