pipeline {
    agent {
        docker {
            image 'shivam139/jenkins-agent-ubuntu:v1'
            args '--user root -v /var/run/docker.sock:/var/run/docker.sock' 

        }
    }

    stages {
        stage('checkout') {
            steps {
                sh 'echo passed...'
            }
        }
        stage('Build & push docker image') {
            steps {
                echo "Building the docker image And then pushing image to the dockerHub"
                withCredentials([usernamePassword(credentialsId: "dockerhub", usernameVariable: "dockerhubUser", passwordVariable: "dockerhubPass")]) {
                    sh '''
                        cd Python-app 
                        docker build -t ${env.dockerhubUser}/streamlit_application:${BUILD_NUMBER} . 
                        docker login -u ${env.dockerhubUser} -p ${env.dockerhubPass} 
                        docker push ${env.dockerhubUser}/streamlit_application:${BUILD_NUMBER}
                    '''
                }
            }
        }
        stage('Update deployment manifest') {
            environment {
                GITHUB_REPO = "streamlit-application"
                GITHUB_USERNAME = "shivampawar777"
            }
            steps {
                withCredentials([string(credentialsId: "gitHub", variable: "GITHUB_TOKEN")]) {
                    sh '''
                        git config user.email "pawarshivam826@gmail.com"
                        git config user.name ${env.GITHUB_USERNAME}
                        sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" Deployment-manifest/deployment.yml
                        git add Deployment-manifest/deployment.yml
                        git commit -m "Updated deployment image to version ${BUILD_NUMBER}"
                        git push https://${env.GTIHUB_TOKEN}@github.com/${GITHUB_USERNAME}/${GITHU_REPO}/ HEAD:main        
                    '''
                }
            }
        }
    }
}
