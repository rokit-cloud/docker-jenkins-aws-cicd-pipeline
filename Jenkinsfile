pipeline {
    agent any

    environment {
        IMAGE_NAME = "rokit45/kanban-dashboard"
        BUILD_TAG  = "build-${BUILD_NUMBER}"
        APP_PORT   = "3000"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${BUILD_TAG} ."
            }
        }

        stage('Docker Hub Login & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DUSER', passwordVariable: 'DPASS')]) {
                    sh "echo \$DPASS | docker login -u \$DUSER --password-stdin"
                    sh "docker push ${IMAGE_NAME}:${BUILD_TAG}"
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                sh """
                docker pull ${IMAGE_NAME}:${BUILD_TAG}
                docker stop kanban-dashboard || true
                docker rm kanban-dashboard || true
                docker run -d --name kanban-dashboard \
                    --memory=256m --cpus=0.5 \
                    -p ${APP_PORT}:${APP_PORT} \
                    ${IMAGE_NAME}:${BUILD_TAG}
                """
            }
        }

        stage('Health Check') {
            steps {
                sh "sleep 5"
                sh "curl -f http://localhost:${APP_PORT} || exit 1"
            }
        }
    }

    post {
        success {
            echo "CI/CD Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed. Rolling back container..."
            sh "docker rm -f kanban-dashboard || true"
        }
    }
}
