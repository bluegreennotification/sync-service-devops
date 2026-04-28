pipeline {
  agent any

  environment {
    PROJECT_ID = "your-gcp-project-id"
    IMAGE = "gcr.io/${PROJECT_ID}/sync-service"
    REGION = "asia-south1"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build & Test') {
      steps {
        sh './mvnw clean verify'
      }
    }

    stage('Static Analysis') {
      steps {
        echo "Run SonarQube scan here"
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          IMAGE_TAG = "${env.BUILD_NUMBER}"
        }
        sh "docker build -t $IMAGE:$IMAGE_TAG ."
      }
    }

    stage('Push Image') {
      steps {
        sh "docker push $IMAGE:$IMAGE_TAG"
      }
    }

    stage('Deploy QA') {
      when { branch 'develop' }
      steps {
        sh "./deploy.sh qa $IMAGE:$IMAGE_TAG"
      }
    }

    stage('Deploy Staging') {
      when { branch 'staging' }
      steps {
        sh "./deploy.sh staging $IMAGE:$IMAGE_TAG"
      }
    }

    stage('Approve Production') {
      when { branch 'main' }
      steps {
        input message: "Approve deployment to Production?"
      }
    }

    stage('Deploy Production') {
      when { branch 'main' }
      steps {
        sh "./deploy.sh prod $IMAGE:$IMAGE_TAG"
      }
    }

    stage('Post-Deploy Verification') {
      steps {
        sh "echo 'Running smoke tests...'"
      }
    }
  }

  post {
    failure {
      sh "./scripts/rollback.sh"
    }
  }
}
