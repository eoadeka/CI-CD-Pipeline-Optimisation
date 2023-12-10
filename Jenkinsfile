pipeline {
  agent any

  environment {
    GITHUB_REPO = 'ella-adeka/CI-CD-Pipeline-Optimisation'
    GITHUB_TOKEN = credentials('github-personal-access-token')
  }
  // dockerhub
  // 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
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

    stage('Create Github Release') {
      // If UAT tests pass, promote the application to the staging environment
      when {
        expression { currentBuild.result == 'SUCCESS' }
      }
      steps {
        script {
          bat 'echo "Invoke Github Actions Workflow"'
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
      emailext (
        subject: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
        body: """<p>SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':<p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
        to: "dassalotbro1@gmail.com"
      )
      // Notify Github of success
      script{
        try {
          // Step 1: Trigger Workflow
          bat 'echo "Invoking Github Actions Workflow"'
          def githubToken = env.GITHUB_TOKEN
          def repo = env.GITHUB_REPO
          def sha = env.GIT_COMMIT

          bat """
            curl -X POST
            -H "Authorization: Bearer ${githubToken}" \
            -H "Accept: application/vnd.github.v3+json" \
            "https://api.github.com/repos/${repo}/statuses/${sha}" \
            -d '{"state": "success", "context": "Jenkins"}'
          """
        }
        catch (Exception e) {
          echo 'Failed to invoke Github Actions: ${e.getMessage()}'
          currentBuild.result = 'FAILURE'
        }
      
      }
    }
    
    failure{
      // Actions to be performed on pipeline failure
      echo 'Pipeline failed. Please review the build logs and fix the issues.'
      emailext (
        subject: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
        body: """<p>FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':<p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
        to: "dassalotbro1@gmail.com"
      )
    }
  }
}
