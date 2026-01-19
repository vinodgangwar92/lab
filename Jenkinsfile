pipeline {
    agent any

    environment {
        REGISTRY = "docker.io/yourdockerhubusername"  // Change this
        IMAGE = "lab-site"                            // Image name
        CREDS = "dockerhub-creds"                     // Jenkins credential ID
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
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    bat '''
                    echo Logging in...
                    docker login %REGISTRY% -u %USER% -p %PASS%
                    '''
                }
            }
        }

        stage('Build Image') {
            steps {
                bat '''
                echo Building image...
                docker build -t %REGISTRY%/%IMAGE%:%BUILD_NUMBER% .
                '''
            }
        }

        stage('Push Image') {
            steps {
                bat '''
                echo Pushing image...
                docker push %REGISTRY%/%IMAGE%:%BUILD_NUMBER%
                docker tag %REGISTRY%/%IMAGE%:%BUILD_NUMBER% %REGISTRY%/%IMAGE%:latest
                docker push %REGISTRY%/%IMAGE%:latest
                '''
            }
        }

    }

    post {
        success { echo "Build & push succeeded!" }
        failure { echo "Build or push failed." }
    }
}
