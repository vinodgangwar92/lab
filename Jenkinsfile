pipeline {
  agent { label 'windows' }
  options { timestamps() }

  environment {
    IMAGE = 'yourhubuser/static-site'   // <- apna Docker Hub repo daalo
    TAG   = "${env.BUILD_NUMBER}"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build site') {
      steps { bat 'echo Building static site on Windows' }
    }

    stage('Docker login') {
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

    stage('Docker build') {
      steps {
        bat '''
          docker build -t %IMAGE%:%TAG% -t %IMAGE%:latest .
        '''
      }
    }

    stage('Docker push') {
      steps {
        bat '''
          docker push %IMAGE%:%TAG%
          docker push %IMAGE%:latest
        '''
      }
    }

    stage('Archive static files') {
      steps {
        archiveArtifacts artifacts: '*/.html, */.css, */.js, images/**', fingerprint: true
      }
    }
  }

  post {
    success { echo "✅ Pushed %IMAGE%:%TAG% and :latest" }
    failure { echo '❌ Build/Push failed — console output dekho' }
  }
}
