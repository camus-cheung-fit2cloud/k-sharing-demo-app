pipeline {
    agent any

    environment {
        IMAGE_NAME = 'registry.fit2cloud.org/demo-app'
        IMAGE_TAG_LATEST = 'latest'
        IMAGE_TAG_TIMESTAMP = new Date().format('yyyyMMdd-HHmmss')
        WATCHTOWER_API_URL = 'http://watchtower:8080/v1/update'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
					url: 'https://github.com/camus-cheung-fit2cloud/k-sharing-demo-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image with the timestamp tag
                    sh """
                        docker build --build-arg CACHEBUST=\$(TZ='Asia/Shanghai' date +%s) -t ${IMAGE_NAME}:${IMAGE_TAG_TIMESTAMP} .
                    """
                    
                    // Tag the image with 'latest'
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG_TIMESTAMP} ${IMAGE_NAME}:${IMAGE_TAG_LATEST}"
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                script {
                    // Push the image with the timestamp tag
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG_TIMESTAMP}"
                    
                    // Push the Docker image with the latest tag
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG_LATEST}"
                }
            }
        }
        
        stage('Trigger watchtower') {
            steps {
                withCredentials([string(credentialsId: 'watchtower', variable: 'WATCHTOWER_TOKEN')]) {
                    httpRequest url: "${env.WATCHTOWER_API_URL}", validResponseCodes: '200', customHeaders: [[name: 'Authorization', value: "Bearer $WATCHTOWER_TOKEN"]]
				}
            }
        }

        stage('Clean Up') {
            steps {
                script {
                    // Clean up any dangling images to free up space
                    sh 'docker system prune -f'
                }
            }
        }
    }

    post {
        success {
            echo "Docker image built and pushed successfully with tags: latest, ${IMAGE_TAG_TIMESTAMP}"
        }
        failure {
            echo "The pipeline failed. Please check the logs."
        }
    }
}
