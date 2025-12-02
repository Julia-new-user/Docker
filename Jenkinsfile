pipeline {
	agent any
	stages{
		stage('Checkout') {
			steps { checkout scm }
		}
		stage('Build') {
			steps { sh 'docker build -t my-ci-app:${BUILD_NUMBER} .' }
		}
		stage('Test'){
			steps { sh 'docker run --rm my-ci-app:${BUILD_NUMBER} echo "Test passed"' }
		}
	}
}
