pipeline {
    agent {
        docker {
            image 'shivam139/jenkins-agent-ubuntu:v2'
            args '--user root -v /var/run/docker.sock:/var/run/docker.sock' 

        }
    }

    stages {
        stage('checkout') {
            steps {
                //git branch: 'main', url: 'https://github.com/shivampawar777/streamlit_application.git' 
                sh 'echo passed...'
            }
        }
        stage('Build & push docker image') {
            steps {
                echo "Building the docker image And then pushing image to the dockerHub"
                withCredentials([usernamePassword(credentialsId: "dockerhub", usernameVariable: "dockerhubUser", passwordVariable: "dockerhubPass")]) {
                    sh 'Python-app && docker build -t ${env.dockerhubUser}/streamlit_application:${BUILD_NUMBER} .'
                    sh 'docker login -u ${env.dockerhubUser} --password-stdin ${env.dockerhubPass}'
                    sh 'docker push ${env.dockerhubUser}/streamlit_application:${BUILD_NUMBER}'
                }
            }
        }
        stage('Update deployment manifest') {
            environment {
                GITHUB_EMAIL = "pawarshivam826@gmail.com"
                GITHUB_USERNAME = "shivampawar777"
                GITHUB_REPO = "streamlit-application"
            }
            steps {
                withCredentials([string(credentialsId: "gitHub", variable: "GITHUB_TOKEN")]) {
                    sh 'git config user.email ${GITUB_EMAIL}'
                    sh 'git config user.name ${env.GITHUB_USERNAME}'
                    sh 'sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" Deployment-manifest/deployment.yml'
                    sh 'git add Deployment-manifest/deployment.yml'
                    sh 'git commit -m "Updated deployment image to version ${BUILD_NUMBER}'
                    sh 'git push https://${env.GTIHUB_TOKEN}@github.com/${GITHUB_USERNAME}/${GITHU_REPO}/ HEAD:main
                }
            }
        }
    }
}
