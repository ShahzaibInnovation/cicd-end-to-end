pipeline {
    
    agent any 
    
    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        
        stage('Checkout'){
            steps {
                git credentialsId: 'github', 
                url: 'https://github.com/ShahzaibInnovation/cicd-end-to-end',
                branch: 'main'
            }
        }

        stage('Build Docker'){
            steps{
                script{
                    sh '''
                    echo 'Build Docker Image'
                    docker build -t devops317/cicd-project:${BUILD_NUMBER} .
                    '''
                }
            }
        }

        stage('Push the artifacts'){
            steps {
                script {
                    // Using Docker Hub credentials to login and push
                    withCredentials([usernamePassword(credentialsId: 'docker-cred', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh '''
                        echo 'Logging in to Docker Hub'
                        docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                        echo 'Push to Docker Hub'
                        docker push devops317/cicd-project:${BUILD_NUMBER}
                        '''
                    }
                }
            }
        }
        
        stage('Checkout K8S manifest SCM'){
            steps {
                git credentialsId: 'github', 
                url: 'https://github.com/ShahzaibInnovation/cicd-end-to-end/deploy',
                branch: 'main'
            }
        }
        
        stage('Update K8S manifest & push to Repo'){
            steps {
                script{
                    withCredentials([usernamePassword(credentialsId: 'github', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                        sh '''
                        cat deploy.yaml
                        sed -i "s/32/${BUILD_NUMBER}/g" deploy.yaml
                        cat deploy.yaml
                        git add deploy.yaml
                        git commit -m 'Updated the deploy yaml | Jenkins Pipeline'
                        git push https://$GIT_USERNAME:$GIT_PASSWORD@github.com/ShahzaibInnovation/cicd-end-to-end/deploy HEAD:main
                        '''                        
                    }
                }
            }
        }
    }
}
