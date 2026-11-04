pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Aditya-sinh/vle8-blue-green-app.git'
            }
        }

        stage('Build Green Image') {
            steps {
                sh '''
                docker build \
                --build-arg APP_VERSION=green \
                -t myapp:v2 .
                '''
            }
        }

        stage('Import Image into K3s') {
            steps {
                sh '''
                docker save myapp:v2 | sudo k3s ctr images import -
                '''
            }
        }

        stage('Deploy Green') {
            steps {
                sh '''
                kubectl apply -f kubernetes/deployment-green.yaml
                kubectl rollout status deployment/myapp-green --timeout=180s
                '''
            }
        }

        stage('Approve Traffic Switch') {
            steps {
                input message: 'Green deployment is ready. Switch traffic from Blue to Green?',
                      ok: 'Switch to Green'
            }
        }

        stage('Switch Traffic') {
            steps {
                sh '''
                kubectl patch service myapp-service \
                -p '{"spec":{"selector":{"app":"myapp","color":"green"}}}'
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                kubectl get deployments
                kubectl get pods
                kubectl get service myapp-service
                curl -f http://localhost:30080
                '''
            }
        }
    }
}
