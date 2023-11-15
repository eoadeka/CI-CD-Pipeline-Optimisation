pipeline {
  agent any

  // environment {
  //   GITHUB_REPO = 'ella-adeka/CI-CD-Pipeline-Optimisation'
  //   GITHUB_TOKEN = credentials('')
  // }

  stages {

    stage('Checkout') {
      // checkout source code from version control
      steps {
        checkout scm
      }
    }

    // Build Stage
    stage('Build') {
      steps {
        script {
          bat 'echo "Building application..."'
          // Build for local/dev environment
          docker build -t ci-cd-pipeline ./my_app
          docker run -dp 5000:5000 ci-cd-pipeline
        }
      }
    }

    // Test Stage
    stage('test') {
      //  Run Unit and Integration Tests
      steps {
        script {
          bat 'echo "Testing application..."'
          bat 'python -m pytest'
        }
      }
    }

    stage('Deploy to UAT') {
      // Deploy the application to the UAT environment
      steps {
        script {
          bat 'echo "Deploying application to UAT..."'
        }
      }
    }

    stage('UAT') {
      //  Run Usability Tests and Acceptance Criteria Verification
      steps {
        script {
          bat 'echo "Running User Acceptance Testing ..."'
        }
      }
    }

    stage('Create Guthub Release') {
      // If UAT tests pass, promote the application to the staging environment
      when {
        expression { currentBuild.result == 'SUCCESS' }
      }
      steps {
        script {
          bat 'echo "Deploying application to Staging and Production..."'
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
