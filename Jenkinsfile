pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = "docker.io/yourdockerhubusername"
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
                    echo Logging in...
                    docker login %DOCKER_REGISTRY% -u %DOCKER_USER% -p %DOCKER_PASS%
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                bat '''
                echo Building Docker image...
                docker build -t %DOCKER_REGISTRY%/%IMAGE_NAME%:%BUILD_NUMBER% .
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                bat '''
                echo Pushing Docker image...
                docker push %DOCKER_REGISTRY%/%IMAGE_NAME%:%BUILD_NUMBER%
                docker tag %DOCKER_REGISTRY%/%IMAGE_NAME%:%BUILD_NUMBER% %DOCKER_REGISTRY%/%IMAGE_NAME%:latest
                docker push %DOCKER_REGISTRY%/%IMAGE_NAME%:latest
                '''
            }
        }

    }

    post {
        success {
            echo "Build & push completed successfully!"
        }
        failure {
            echo "Build or push failed — check logs."
        }
    }
}
