pipeline {
    agent {
        docker {}
    }

    stages {
        stage('checkout') {
            steps {
        
            }
        }        
        stage('Build & push docker image') {
            steps {
                sh "docker build -t shivam139/streamlit_application:v1 . "
                sh "docker login -u <---> -p <--->"
                sh "docker push shivam139/streamlit_application:v1"
            }
        }
        stage('Deployment') {
            steps {
                
            }
        }
    }
}
