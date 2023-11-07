pipeline {
  agent any

  stages {
    stage('build') {
      steps {
        script {
          bat 'echo "Building application..."'
        }
      }
    }

    stage('test') {
      steps {
        script {
          bat 'echo "Testing application..."'
        }
      }
    }

    stage('deploy') {
      steps {
        script {
          bat 'echo "Deploying application..."'
        }
      }
    }
  }

  post {
    always {
      // Cleanup actions
      echo 'Always executing cleanup...'
    }
    
    success{
      // Actions to be performed on successful execution
      echo 'Pipeline succeeded!'
    }
    
    failure{
      // Actions to be performed on pipeline failure
      echo 'Pipeline failed. Please review the build logs and fix the issues.'
    }
  }
}
