pipeline {
  agent { label 'windows' }
  options { timestamps() }

  environment {
    IMAGE = 'vinodgangwar92/static-site'   // <-- your Docker Hub repo (create it if needed)
    TAG   = "${env.BUILD_NUMBER}"
  }

  stages {
    stage('Checkout') { steps { checkout scm } }

    stage('Diag') {
      steps {
        bat '''
          echo ---- whoami / docker ----
          whoami
          docker --version
          docker info | findstr /I "Server"
          echo ---- workspace listing ----
          cd
          dir /b
        '''
      }
    }

    stage('Login to Docker Registry') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub',
                                          usernameVariable: 'DH_USER',
                                          passwordVariable: 'DH_PASS')]) {
          bat '''
            docker logout
            echo %DH_PASS% | docker login -u %DH_USER% --password-stdin
          '''
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        bat '''
          echo ---- building image ----
          docker build -f Dockerfile -t %IMAGE%:%TAG% -t %IMAGE%:latest .
        '''
      }
    }

    stage('Push Docker Image') {
      steps {
        bat '''
          echo ---- pushing image ----
          docker push %IMAGE%:%TAG%
          docker push %IMAGE%:latest
        '''
      }
    }
  }

  post {
    success { echo "✅ Pushed %IMAGE%:%TAG% and :latest" }
    failure { echo '❌ Build/Push failed — check the Diag/Build logs above' }
  }
}
