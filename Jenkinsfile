pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = "docker.io/yourdockerhubusername"   // your Docker Hub registry
        IMAGE_NAME = "lab-site"                                // name you want for the image
        CREDENTIALS_ID = "dockerhub-creds"                      // Jenkins credentials ID
    }

    stages {

        stage('Checkout') {
            steps {
                git url: 'https://github.com/vinodgangwar92/lab.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build image and tag with Jenkins BUILD_NUMBER
                    dockerImage = docker.build("${DOCKER_REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Push Image to Registry') {
            steps {
                script {
                    // Login and push image with tags
                    docker.withRegistry("https://${DOCKER_REGISTRY}", "${CREDENTIALS_ID}") {
                        dockerImage.push("${env.BUILD_NUMBER}")
                        dockerImage.push("latest")
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Docker image built and pushed successfully!"
        }
        failure {
            echo "Docker build or push failed! Check logs."
        }
    }
}
