pipeline {
  agent { label 'windows' }
  options { timestamps() }
  environment {
    IMAGE = 'yourhubuser/static-site'   // <- apna Docker Hub repo
    TAG   = "${env.BUILD_NUMBER}"
  }
  stages {
    stage('Checkout'){ steps { checkout scm } }

    stage('Build site'){ steps { bat 'echo Building on Windows' } }

    stage('Docker login'){
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
          bat '''
            docker logout
            echo %DH_PASS% | docker login -u %DH_USER% --password-stdin
          '''
        }
      }
    }

    stage('Docker build'){
      steps { bat 'docker build -t %IMAGE%:%TAG% -t %IMAGE%:latest .' }
    }

    stage('Docker push'){
      steps {
        bat 'docker push %IMAGE%:%TAG%'
        bat 'docker push %IMAGE%:latest'
      }
    }
  }
  post {
    success { echo "✅ Pushed %IMAGE%:%TAG% and :latest" }
    failure { echo '❌ Build/Push failed — console output check karein' }
  }
}
