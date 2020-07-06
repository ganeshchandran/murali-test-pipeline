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
                emailext body: 'Jenkins Sample Email', subject: 'Jenkins Build Success', to: 'ganeshchandran@live.in'
            }
        }
    }
}
