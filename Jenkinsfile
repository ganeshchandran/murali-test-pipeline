pipeline {
    parameters {
        choice(name: 'BRANCH', choices: ['master', 'feature1', 'feature2'], description: 'Select the Branch')
	choice(name: 'ENVIRONMENT', choices: ['dev', 'uat', 'prod'], description: 'Select the Environment to Deploy')
    }
    agent any

    stages {   
	stage('WS-Cleanup') {
            steps {
		    cleanWs()
            }
        }
        stage('Checkout') {
            steps {
		    git branch: "${params.BRANCH}", url: 'https://github.com/ganeshchandran/javahometech-jenkin-demo.git'
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
		 nexusArtifactUploader(
                            nexusVersion: 'nexus3',
                            protocol: 'http',
                            nexusUrl: 'localhost:8081',
                            groupId: pom.groupId,
                            version: pom.version,
                            repository: 'first-pipeline',
                            credentialsId: 'nexus-credentials',
                            artifacts: [
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: artifactPath,
                                type: pom.packaging],
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: "pom.xml",
                                type: "pom"]
                            ]
                        );
	       }
            }
			}
	stage('Docker build and push') {
            steps {
		script {
			docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credential')
			{
			dockerImage = docker.build "registry.hub.docker.com/ganeshchandran/jenkin-pipeline:$BUILD_NUMBER-${params.BRANCH}"
			dockerImage.push()
			
			}
			sh "docker rmi registry.hub.docker.com/ganeshchandran/jenkin-pipeline:$BUILD_NUMBER-${params.BRANCH}"
			sh "sed -i s/jenkin-pipeline:build-number/jenkin-pipeline:$BUILD_NUMBER-${params.BRANCH}/g jenkins-deployment.yaml"
			sh "sed -i s/namespace-value/${params.ENVIRONMENT}/g jenkins-deployment.yaml"
                        sh "sed -i s/namespace-value/${params.ENVIRONMENT}/g jenkins-deployment-service.yaml"
		}
            }
        }
	stage('Deploy to GKE') {
           steps {
	       script {
		      if (params.ENVIRONMENT == 'dev') {
		      echo 'Deploying code in k8s Dev'
                      step([
                      $class: 'KubernetesEngineBuilder',
                      projectId: 'inlaid-micron-268506',
                      clusterName: 'prod',
                      location: 'us-central1-c',
                      manifestPattern: 'jenkins-deployment.yaml',
                      credentialsId: 'inlaid-micron-268506',
                      verifyDeployments: false])
		
		      step([
                      $class: 'KubernetesEngineBuilder',
                      projectId: 'inlaid-micron-268506',
                      clusterName: 'prod',
                      location: 'us-central1-c',
                      manifestPattern: 'jenkins-deployment-service.yaml',
                      credentialsId: 'inlaid-micron-268506',
                      verifyDeployments: false])
                   } 
		   else if (params.ENVIRONMENT == 'uat') {
                      echo 'Deploying code in k8s UAT'
                      step([
                      $class: 'KubernetesEngineBuilder',
                      projectId: 'inlaid-micron-268506',
                      clusterName: 'prod',
                      location: 'us-central1-c',
                      manifestPattern: 'jenkins-deployment.yaml',
                      credentialsId: 'inlaid-micron-268506',
                      verifyDeployments: false])
		
		      step([
                      $class: 'KubernetesEngineBuilder',
                      projectId: 'inlaid-micron-268506',
                      clusterName: 'prod',
                      location: 'us-central1-c',
                      manifestPattern: 'jenkins-deployment-service.yaml',
                      credentialsId: 'inlaid-micron-268506',
                      verifyDeployments: false])
		   }
		   else if (params.ENVIRONMENT == 'prod') {
                      echo 'Deploying code in k8s Prod'
                      step([
                      $class: 'KubernetesEngineBuilder',
                      projectId: 'inlaid-micron-268506',
                      clusterName: 'prod',
                      location: 'us-central1-c',
                      manifestPattern: 'jenkins-deployment.yaml',
                      credentialsId: 'inlaid-micron-268506',
                      verifyDeployments: false])
		
		      step([
                      $class: 'KubernetesEngineBuilder',
                      projectId: 'inlaid-micron-268506',
                      clusterName: 'prod',
                      location: 'us-central1-c',
                      manifestPattern: 'jenkins-deployment-service.yaml',
                      credentialsId: 'inlaid-micron-268506',
                      verifyDeployments: false])    
                   }
		   else {
                      echo 'No valid environment selected for deployment'    
                   }
	       }
	   }
	}
	    
        //stage('Email Notification') {
        //    steps {
        //        mail bcc: '', body: 'Jenkins Sample Email', cc: '', from: '', replyTo: '', subject: 'Jenkins Build Success', to: 'ganeshchandran@live.in'
        //    }
        //}
 }
 }
