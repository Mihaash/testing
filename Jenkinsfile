pipeline {
    agent any

    parameters {
        booleanParam(name: 'RUN_DOCKER', defaultValue: false, description: 'Run Docker container?')
        booleanParam(name: 'DEPLOY', defaultValue: false, description: 'Deploy to EC2?')
    }

    environment {
        IMAGE = "mickey06/testing"
    }

    stages {

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

        stage('Run Docker Container') {
            when {
                expression { params.RUN_DOCKER }
            }
            steps {
                sh '''
                docker stop myapp || true
                docker rm myapp || true
                docker run -d -p 8080:8080 --name myapp $IMAGE:latest
                '''
            }
        }

        stage('Deploy to EC2') {
            when {
                expression { params.DEPLOY }
            }
            steps {
                sh '''
                terraform apply -auto-approve
                '''
            }
        }
    }
}
