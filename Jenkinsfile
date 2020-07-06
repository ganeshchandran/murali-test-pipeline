pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/ganeshchandran/javahometech-jenkin-demo.git'
            }
        }
        stage('Maven Build') {
            steps {
                sh "mvn clean package"
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv(installationName: 'sonarqube') { // You can override the credential to be used
                sh 'mvn sonar:sonar'
                }
            }
        }
        stage('Email Notification') {
            steps {
                mail bcc: '', body: 'Jenkins Sample Email', cc: '', from: '', replyTo: '', subject: 'Jenkins Build Success', to: 'ganeshchandran@live.in'
            }
        }
    }
}
