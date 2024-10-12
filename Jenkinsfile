pipeline {
    
    agent any 
    
    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        
        stage('Checkout'){
           steps {
                git credentialsId: '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', 
                url: 'https://github.com/ShahzaibInnovation/cicd-end-to-end',
                branch: 'main'
           }
        }

        stage('Build Docker'){
            steps{
                script{
                    sh '''
                    echo 'Buid Docker Image'
                    docker build -t devops317/cicd-project:${BUILD_NUMBER} .
                    '''
                }
            }
        }

        stage('Push the artifacts'){
           steps{
                script{
                    sh '''
                    echo 'Push to Repo'
                    docker push  devops317/cicd-project:${BUILD_NUMBER}
                    '''
                }
            }
        }
        
        stage('Checkout K8S manifest SCM'){
            steps {
                git credentialsId: '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', 
                url: 'https://github.com/ShahzaibInnovation/cicd-end-to-end/deploy',
                branch: 'main'
            }
        }
        
        stage('Update K8S manifest & push to Repo'){
            steps {
                script{
                    withCredentials([usernamePassword(credentialsId: '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', passwordVariable: 'github', usernameVariable: 'GIT_USERNAME')]) {
                        sh '''
                        cat deploy.yaml
                        sed -i '' "s/32/${BUILD_NUMBER}/g" deploy.yaml
                        cat deploy.yaml
                        git add deploy.yaml
                        git commit -m 'Updated the deploy yaml | Jenkins Pipeline'
                        git remote -v
                        git push https://github.com/ShahzaibInnovation/cicd-end-to-end/deploy HEAD:main
                        '''                        
                    }
                }
            }
        }
    }
}
