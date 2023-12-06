pipeline {
  agent any

  // environment {
  //   GITHUB_REPO = 'ella-adeka/CI-CD-Pipeline-Optimisation'
  //   GITHUB_TOKEN = credentials('')
  // }
  // dockerhub

  stages {

    stage('Checkout') {
      // checkout source code from version control
      steps {
        checkout scm
      }
    }

    // Build Stage
    stage('Build Image') {
      steps {
        script {
          bat 'echo "Building application..."'
          // Build for local/dev environment
          bat 'docker build -t ella-adeka/ci-cd-pipeline ./my_app'
        }
      }
    }

    // Test Stage
    stage('Test') {
      //  Run Unit and Integration Tests
      steps {
        script {
          bat 'echo "Testing application..."'
          bat 'python -m pytest'
        }
      }
    }

    // Push Image to Dockerhub
    stage("Deploy to DockerHub") {
      steps {
        // Deploy application
        script {
          bat 'echo "Deploying application to dockerhub..."'
          withCredentials([string(credentialsId: 'dockerhubsecrets', variable: 'dockerhubpwd')]) {
            // log in to Docker hub
            bat "docker login -u ellaadeka -p ${dockerhubpwd}"
          }
          // Push image to dockerhub
          bat 'docker tag ci-cd-pipeline ellaadeka/ci-cd-pipeline'
          bat 'docker push ellaadeka/ci-cd-pipeline'
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
      mail bcc: '', body: "<b>Pipeline succeeded<b><br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER}<br> Build URL: ${env.BUILD_URL}", cc: '', from: 'eoadeka@gmail.com', replyTo: '', subject: "PIPELINE SUCCESS: Project Name -> ${env.JOB_NAME}", to: 'dassalotbro1@gmail.com'    }
    
    failure{
      // Actions to be performed on pipeline failure
      echo 'Pipeline failed. Please review the build logs and fix the issues.'
    }
  }
}
