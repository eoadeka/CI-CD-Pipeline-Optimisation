pipeline {
  agent any

  environment {
    AWS_DEFAULT_REGION = 'eu-west-2'
    GITHUB_REPO = 'ella-adeka/CI-CD-Pipeline-Optimisation'
    GITHUB_TOKEN = credentials('github-personal-access-token')
    GLOBAL_ENVIRONMENT = 'no_deploy'
    TF_WORKING_DIR = 'terraform/environments'
    // AWS_CREDITS = ('ella-adeka-aws-credentials')
  }

  tools {
    terraform 'terraform'
  }

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
          echo "Building application..."
          // Build for local/dev environment
          bat 'docker build -t ella-adeka/ci-cd-pipeline ./my_app'
        }
      }
    }

    // Test Stage
    stage('Testing - Dev') {
      //  Run Unit and Integration Tests
      steps {
        script {
          echo "Testing application..."
          bat 'python -m pytest ./tests/integration/test_app.py'
        }
      }
    }

    // Push Image to Dockerhub
    stage("Push Image to DockerHub") {
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

    stage("Deployment - Dev") {
      when {
        branch 'sandbox'
      }
      steps {
        script {
          echo "Deploying to dev environment..."
          dir("${TF_WORKING_DIR}/dev/") {
            deployInfra(dev)
          }
        }
      }
    }

    stage("Deployment - Staging") {
      when {
        branch 'production'
      }
      stage ('Test Staging') {
        steps {
          script {
            echo "Testing staging environment..."
            bat '''
              python -m pip install --upgrade pip
              pip install -r ./my_app/requirements.txt
              npx playwright install
              npx playwright install-deps
            '''
          }
        }
      }
      stage ('Deploy Staging') {
        steps {
          script {
            echo "Deploying to staging environment..."
            dir("${TF_WORKING_DIR}/staging/") {
              deployInfra(staging)
            }
          }
        }
      }
    }

    stage("Deployment - Production") {
      when {
        // Deploy to production only if user confirms
        branch 'production'
        echo 'Staging tests passed!'
        input 'Deploy to production?'
      }
      steps {
        script {
          dir("${TF_WORKING_DIR}/production/") {
           deployInfra(production)
          }
        }
      }
    }
  }

  post {
    always {
      // Cleanup actions
      echo 'Always executing cleanup...'
      echo 'destroying Terraform resources'
      script {
        dir ("terraform/environments/") {
          bat "terraform destroy -auto-approve"
        }
      }
    }
    
    success{
      // Actions to be performed on successful execution
      echo 'Pipeline succeeded! Notifying Github for release'
      emailext (
        subject: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
        body: """<p>SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':<p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
        to: "dassalotbro1@gmail.com"
      )
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

// Function to deploy infrastructure using Terraform
def deployInfra(environment) {
  echo "Provisioning infrastructure for ${environment} environment"
  withAWS(credentials: 'ella-adeka-aws-credentials', region: 'eu-west-2') {
    // Initialise Terraform
    bat 'terraform init -reconfigure'

    // Check for syntax errors and validate configuration
    bat 'terraform validate'

    // View resources to be deployed
    bat 'terraform plan -out tfplan${environment}.out'

    parameters([
      choice(
        choices: ['apply', 'destroy'],
        name: 'action'
      )
    ])

    // Perform terrraform action Terraform
    echo "Terraform action is --> ${action}"
    bat "terraform ${action} -auto-approve -input=false"
  }
}