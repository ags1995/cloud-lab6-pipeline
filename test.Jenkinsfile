pipeline {
    agent {
        label 'ahmad-node'
    }
    
    stages {
        stage('Test') {
            steps {
                echo "=== Testing ahmad-node ==="
                sh '''
                    echo "Hostname: $(hostname)"
                    echo "User: $(whoami)"
                    echo "Date: $(date)"
                    echo "Working dir: $(pwd)"
                    echo "Java: $(java -version 2>&1 | head -1)"
                    echo "Git: $(git --version)"
                    ls -la
                '''
            }
        }
    }
    
    post {
        success {
            echo "✅ ahmad-node test successful!"
        }
        failure {
            echo "❌ ahmad-node test failed!"
        }
    }
}
