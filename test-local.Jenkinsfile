pipeline {
    agent any
    
    stages {
        stage('Test') {
            steps {
                echo "Local test of Jenkinsfile syntax"
                sh '''
                    echo "Testing on local machine"
                    echo "Git HTTP version fix test"
                    git config --global http.version HTTP/1.1 || true
                    git config --global http.postBuffer 1048576000 || true
                    echo "Test successful"
                '''
            }
        }
    }
}
