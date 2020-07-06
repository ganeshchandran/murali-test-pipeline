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
	       script {
		 pom = readMavenPom file: "pom.xml";
		 filesByGlob = findFiles(glob: "target/*.${pom.packaging}");      
		 echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
		 artifactPath = filesByGlob[0].path;
		 artifactExists = fileExists artifactPath;
                 nexusArtifactUploader )artifacts: [[artifactId: 'pom.artifactId', classifier: '', file: artifactPath, type: pom.packaging],[artifactId: 'pom.artifactId', classifier: '', file: pom.xml, type: pom]], credentialsId: 'nexus-credentials', groupId: 'pom.groupId', nexusUrl: 'localhost:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'first-pipeline', version: 'pom.version');
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
