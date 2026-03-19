pipeline {
  agent any

  environment {
    IMAGE_REPO = "oliveret/swe642-assignment1"
    IMAGE_TAG = "${BUILD_NUMBER}"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build and Push Multi-Arch Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
        sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker buildx create --use --name jxbuilder || true
            docker buildx build \
            --platform linux/amd64,linux/arm64 \
            -t ${IMAGE_REPO}:${IMAGE_TAG} \
            -t ${IMAGE_REPO}:latest \
            --push .
        '''
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        sh '''
          kubectl apply -f k8s-deployment.yaml
          kubectl set image deployment/swe642-assignment1-deployment swe642-assignment1=${IMAGE_REPO}:${IMAGE_TAG}
          kubectl rollout status deployment/swe642-assignment1-deployment
        '''
      }
    }
  }
}