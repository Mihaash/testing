pipeline {
    agent any
    environment {
        IMAGE = "mickey06/testing"
    }
    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/Mihaash/testing'
            }
        }
        stage('Build with Maven') {
            steps {
                dir('app') {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE:latest .'
            }
        }
        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                    echo $PASS | docker login -u $USER --password-stdin
                    docker push $IMAGE:latest
                    '''
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml
                '''
            }
        }
    }
}
