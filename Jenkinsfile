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
        stage('Nexus Artifact Upload') {
            steps {
                nexusArtifactUploader artifacts: [[artifactId: 'pom.artifactId', classifier: '', file: '/var/lib/jenkins/workspace/first-pipeline/target/', type: 'war']], credentialsId: 'nexus-credentials', groupId: 'pom.groupId', nexusUrl: 'localhost', nexusVersion: 'nexus3', protocol: 'http', repository: 'first-pipeline', version: 'pom.version'
            }
        stage('Email Notification') {
            steps {
                mail bcc: '', body: 'Jenkins Sample Email', cc: '', from: '', replyTo: '', subject: 'Jenkins Build Success', to: 'ganeshchandran@live.in'
            }
        }
    }
}
