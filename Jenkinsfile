pipeline {
    agent any

    parameters {
        booleanParam(name: 'DEPLOY', defaultValue: false, description: 'Deploy to Kubernetes?')
    }

    environment {
        IMAGE = "mickey06/testing"
    }

    stages {
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

        stage('Deploy to ec2') {
            when {
                expression { params.DEPLOY == true }
            }
            steps {
                sh '''
                terraform apply -auto-approve /terraform
                '''
            }
        }
    }
}
