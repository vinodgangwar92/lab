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

        stage('Verify Docker') {
            steps {
                powershell '''
                Write-Host "Checking Docker availability..."
                docker --version
                docker info
                '''
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
                docker build --progress=plain -t ${DOCKER_REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER} .
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
        success { echo "Success: build & push complete" }
        failure { echo "Failed: check output above for detail" }
    }
}
